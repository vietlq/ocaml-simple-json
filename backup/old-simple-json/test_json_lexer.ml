let string_of_token token =
  match token with
  | Token.T_OBJ_BEGIN     -> "T_OBJ_BEGIN"
  | Token.T_OBJ_END       -> "T_OBJ_END"
  | Token.T_ARR_BEGIN     -> "T_ARR_BEGIN"
  | Token.T_ARR_END       -> "T_ARR_END"
  | Token.T_COLON         -> "T_COLON"
  | Token.T_COMMA         -> "T_COMMA"
  | Token.T_STRING strVal -> strVal
  | Token.T_NUMBER number -> string_of_float number
  | Token.T_TRUE          -> "true"
  | Token.T_FALSE         -> "false"
  | Token.T_NULL          -> "null"

let rec main_loop stream =
  match Stream.peek stream with
  | None -> ()
  | Some token ->
    Stream.junk stream;
    print_endline (string_of_token token);
    print_string "ready> "; flush stdout;
    main_loop stream

let main () =
  print_string "ready> "; flush stdout;
  let stream = Lexer.lex (Stream.of_channel stdin) in
  main_loop stream
;;

main()
