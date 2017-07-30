let parse_in_chan in_chan () =
  Parser.parse_top_level @@ Lexer.lex @@ Stream.of_channel @@ in_chan

let parse_file file () =
  parse_in_chan (open_in file) ()

let check_json_file file () =
  try
    match parse_file file () with
    | None ->
    Printf.printf "%s: Nothing\n" file
    | Some (Parser.Error e, _) ->
    Printf.printf "%s: BAD\n\tError: %s\n" file e
    | Some (Parser.Ok _, _) ->
    Printf.printf "%s: GOOD\n" file
  with
  | Failure s ->
    Printf.printf "%s: BAD\n\tException: %s\n" file s
  | _ ->
    Printf.printf "%s: BAD\n\tUnknown exception!\n" file

let () =
  match Array.length Sys.argv with
  | 2 -> check_json_file Sys.argv.(1) ()
  | _ -> Printf.printf "Usage: %s file.json\n" Sys.argv.(0)
