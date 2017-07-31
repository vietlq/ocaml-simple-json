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
        if c == '0' then
          match Stream.peek stream with
          | Some c ->
            begin
              match c with
              | 'e' | 'E' | '.' -> lex_number buffer stream
              | '0'..'9' -> failwith "Numbers cannot have leading zeroes!"
              | _ -> lex_number buffer stream
            end
          | _ -> lex_number buffer stream
        else lex_number buffer stream
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
  (* Non-printable chars must be escaped *)
  | '\x00' .. '\x1f' | '\x7f' .. '\xff' ->
    failwith "Non-printable chars must be escaped!"
  (* Note: "\"" == "\x22", and "\\" == "\x5c" *)
  | '\x20' | '\x21' | '\x23' .. '\x5b' | '\x5d' .. '\x7e' as c ->
    Buffer.add_char buffer c ;
    lex_string buffer stream
  | '\\' ->
    begin
      match Stream.next stream with
      | 'u' ->
        begin
          Buffer.add_char buffer '\\' ;
          Buffer.add_char buffer 'u' ;
          lex_unicode buffer stream
        end
      | '"'  -> Buffer.add_char buffer '"'
      | '\\' -> Buffer.add_char buffer '\\'
      | '/'  -> Buffer.add_char buffer '/'
      | 'b'  -> Buffer.add_char buffer '\b'
      | 'f'  -> Buffer.add_char buffer '\x0c'
      | 'n'  -> Buffer.add_char buffer '\n'
      | 'r'  -> Buffer.add_char buffer '\r'
      | 't'  -> Buffer.add_char buffer '\t'
      | _ -> failwith "Invalid escape character!"
    end ;
    lex_string buffer stream
  | '"' ->
    let str = (Buffer.contents buffer) in
    Some (Token.T_STRING str, stream)

and lex_hex buffer stream =
  match Stream.peek stream with
  | None -> failwith "Premature ending. Expected escaped unicode"
  | Some c ->
    begin
      match c with
      | 'a'..'f' | 'A'..'F' | '0'..'9' ->
        Stream.junk stream ;
        Buffer.add_char buffer c
      | _ -> failwith "Expected escaped unicode"
    end

and lex_unicode buffer stream =
  lex_hex buffer stream ;
  lex_hex buffer stream ;
  lex_hex buffer stream ;
  lex_hex buffer stream

and lex_number buffer stream =
  match Stream.peek stream with
  | Some ('0'..'9' | '.' | '-' | '+' | 'E' | 'e' as c) ->
    Stream.junk stream ;
    Buffer.add_char buffer c ;
    lex_number buffer stream
  | _ ->
    let num = (float_of_string (Buffer.contents buffer)) in
    Some (Token.T_NUMBER num, stream)

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
