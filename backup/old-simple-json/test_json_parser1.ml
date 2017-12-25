(*
  Test the 1st version of camlp4 JSON parser.
  No error recovery available.
*)

let rec main_loop stream =
  match Stream.peek stream with
  | None -> ()
  | Some json_value ->
    Stream.junk stream;
    print_endline (Json.string_of_json json_value);
    print_string "ready> "; flush stdout;
    main_loop stream

let main () =
  print_string "ready> "; flush stdout;
  let stream = Lexer.lex (Stream.of_channel stdin) in
  let stream = Parser1.parse_top_level stream in
  main_loop stream
;;

main()
