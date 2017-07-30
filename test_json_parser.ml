let rec main_loop parse_res =
  match parse_res with
  | None -> ()
  | Some (Parser.Error e, stream) ->
    prerr_endline e; flush stderr;
    main_loop (Parser.parse_top_level @@ Lexer.lex stream)
  | Some (Parser.Ok (json_value: Json.value), stream) ->
    print_endline (Json.string_of_json json_value);
    print_string "ready> "; flush stdout;
    main_loop @@ Parser.parse_top_level @@ Lexer.lex stream

let main () =
  print_string "ready> "; flush stdout;
  let lex_res = Lexer.lex (Stream.of_channel stdin) in
  main_loop @@ Parser.parse_top_level lex_res
;;

main()
