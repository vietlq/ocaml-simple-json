let rec lex stream =
  match Stream.peek stream with
  (* The end of stream *)
  | None -> Stream.from (fun _ -> None)
  | Some c -> begin
    match c with
    (* Ignore white spaces *)
    | ' ' | '\t' | '\n' | '\r' -> Stream.junk stream; lex stream
    (* Important characters *)
    | '{' -> Stream.from (fun _ -> Some Token.T_OBJ_BEGIN)
    | '}' -> Stream.from (fun _ -> Some Token.T_OBJ_END)
    | '[' -> Stream.from (fun _ -> Some Token.T_ARR_BEGIN)
    | ']' -> Stream.from (fun _ -> Some Token.T_ARR_END)
    | ':' -> Stream.from (fun _ -> Some Token.T_COLON)
    | ',' -> Stream.from (fun _ -> Some Token.T_COMMA)
    (* Lex a string *)
    | '"' ->
      let buffer = Buffer.create 1 in
      lex_string buffer stream
    (* Lex a number *)
    | '-' -> | '0'..'9' as c); stream >] ->
      let buffer = Buffer.create 1 in
      Buffer.add_char buffer c;
      lex_number buffer stream
    (* Lex true/false/null *)
    | 't' | 'f' | 'n' as c ->
      let buffer = Buffer.create 1 in
      Buffer.add_char buffer c;
      lex_tfn buffer stream
    | c -> failwith (Printf.sprintf "Invalid character: %c" c)
    end

and lex_string buffer = parser
  (* Note: "\"" == "\x22", and "\\" == "\x5c" *)
  | [< ' ('\x00' .. '\x21' | '\x23' .. '\x5b' | '\x5d' .. '\xff' as c); stream >] ->
    Buffer.add_char buffer c;
    lex_string buffer stream
  | [< ' ('\\'); stream >] ->
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
    Stream.junk stream;
    lex_string buffer stream
  | [< ' ('"'); stream=lex >] ->
    [< 'Token.T_STRING (Buffer.contents buffer); stream >]

and lex_number buffer = parser
  | [< ' ('0' .. '9' | '.' | 'E' | 'e' as c); stream >] ->
    Buffer.add_char buffer c;
    lex_number buffer stream
  | [< stream=lex >] ->
    [< 'Token.T_NUMBER (float_of_string (Buffer.contents buffer)); stream >]

and lex_tfn buffer = parser
  | [< ' ('a' .. 'z' as c); stream >] ->
    Buffer.add_char buffer c;
    lex_tfn buffer stream
  | [< stream=lex >] ->
    match Buffer.contents buffer with
    | "true" -> [< 'Token.T_TRUE; stream >]
    | "false" -> [< 'Token.T_FALSE; stream >]
    | "null" -> [< 'Token.T_NULL; stream >]
    | s -> failwith (Printf.sprintf "Invalid literal: %s" s)
