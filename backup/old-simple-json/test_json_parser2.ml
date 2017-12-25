let rec main_loop orig_stream =
  match Stream.peek orig_stream with
  | None -> ()
  | Some (Parser2.Error e, stream) ->
    prerr_endline e; flush stderr;
    Stream.junk stream;
    main_loop (Parser2.parse_top_level stream)
  | Some (Parser2.Ok (json_value: Json.value), stream) ->
    Stream.junk orig_stream;
    print_endline (Json.string_of_json json_value);
    print_string "ready> "; flush stdout;
    main_loop (Parser2.parse_top_level stream)

let main () =
  print_string "ready> "; flush stdout;
  let stream = Lexer.lex (Stream.of_channel stdin) in
  let stream = Parser2.parse_top_level stream in
  main_loop stream
;;

main()
