let rec lex stream =
  let ret_val t stream =
    Stream.junk stream;
    Some (t, stream)
  in
  match Stream.peek stream with
  (* The end of stream *)
  | None -> None
  | Some c -> begin
    match c with
    (* Ignore white spaces *)
    | ' ' | '\t' | '\n' | '\r' -> Stream.junk stream ; lex stream
    (* Important characters *)
    | '{' -> ret_val Token.T_OBJ_BEGIN stream
    | '}' -> ret_val Token.T_OBJ_END stream
    | '[' -> ret_val Token.T_ARR_BEGIN stream
    | ']' -> ret_val Token.T_ARR_END stream
    | ':' -> ret_val Token.T_COLON stream
    | ',' -> ret_val Token.T_COMMA stream
    (* Lex a string *)
    | '"' ->
      let buffer = Buffer.create 1 in
      Stream.junk stream ;
      lex_string buffer stream
    (* Lex a number *)
    | '-' | '0'..'9' as c ->
      let buffer = Buffer.create 1 in
      Stream.junk stream ;
      Buffer.add_char buffer c ;
      lex_number buffer stream
    (* Lex true/false/null *)
    | 't' | 'f' | 'n' as c ->
      let buffer = Buffer.create 1 in
      Stream.junk stream ;
      Buffer.add_char buffer c ;
      lex_tfn buffer stream
    | c -> failwith (Printf.sprintf "Invalid character: %c" c)
    end

and lex_string buffer stream =
  match Stream.next stream with
  (* Note: "\"" == "\x22", and "\\" == "\x5c" *)
  | '\x00' .. '\x21' | '\x23' .. '\x5b' | '\x5d' .. '\xff' as c ->
    Buffer.add_char buffer c ;
    lex_string buffer stream
  | ('\\') ->
    begin
      match Stream.peek stream with
      | None -> failwith "Invalid string!"
      | Some '"'  -> Buffer.add_char buffer '"'
      | Some '\\' -> Buffer.add_char buffer '\\'
      | Some '/'  -> Buffer.add_char buffer '/'
      | Some 'b'  -> Buffer.add_char buffer '\b'
      | Some 'f'  -> Buffer.add_char buffer '\x0c'
      | Some 'n'  -> Buffer.add_char buffer '\n'
      | Some 'r'  -> Buffer.add_char buffer '\r'
      | Some 't'  -> Buffer.add_char buffer '\t'
      | Some _ -> failwith "Invalid escape character!"
    end ;
    lex_string buffer stream
  | '"' ->
    Some (Token.T_STRING (Buffer.contents buffer), stream)

and lex_number buffer stream =
  match Stream.peek stream with
  | Some ('0'..'9' | '.' | 'E' | 'e' as c) ->
    Stream.junk stream ;
    Buffer.add_char buffer c ;
    lex_number buffer stream
  | _ ->
    Some (Token.T_NUMBER (float_of_string (Buffer.contents buffer)), stream)

and lex_tfn buffer stream =
  match Stream.peek stream with
  | Some ('a' .. 'z' as c) ->
    Stream.junk stream ;
    Buffer.add_char buffer c ;
    lex_tfn buffer stream
  | _ ->
    match Buffer.contents buffer with
    | "true" -> Some (Token.T_TRUE, stream)
    | "false" -> Some (Token.T_FALSE, stream)
    | "null" -> Some (Token.T_NULL, stream)
    | s -> failwith (Printf.sprintf "Invalid literal: %s" s)
