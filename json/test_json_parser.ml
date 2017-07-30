let prompt = "json> "

let rec main_loop parse_res =
  try
    match parse_res with
    | None -> print_endline "  \n\nGoodbye!\n"
    | Some (Parser.Error e, stream) ->
      prerr_endline e; flush stderr;
      print_string prompt; flush stdout;
      main_loop @@ Parser.parse_top_level @@ Lexer.lex stream
    | Some (Parser.Ok (json_value: Json.value), stream) ->
      print_endline (Json.string_of_json json_value);
      print_string prompt; flush stdout;
      main_loop @@ Parser.parse_top_level @@ Lexer.lex stream
  with
  | Failure s ->
    print_endline s;
    flush stdout
  | _ ->
    Printexc.print_backtrace stdout;
    flush stdout

let main () =
  print_string prompt; flush stdout;
  let lex_res = Lexer.lex (Stream.of_channel stdin) in
  main_loop @@ Parser.parse_top_level lex_res
;;

main()
