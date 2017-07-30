let parse_in_chan in_chan () =
  Parser.parse_top_level @@ Lexer.lex @@ Stream.of_channel @@ in_chan

let parse_file file () =
  parse_in_chan (open_in file) ()

let time f =
  let t = Sys.time () in
  let res = f () in
  Printf.printf "\nExecution time: %fs\n" (Sys.time() -. t) ;
  res

let verbose = ref false
let file_name = ref ""
let ask_help = ref false
let speclist = [
  ("-v", Arg.Set verbose, "Prints JSON after parsing");
  ("-f", Arg.Set_string file_name, "JSON file name. Omit for STDIN");
  ("-h", Arg.Set ask_help, "Print help")
]

let usage_msg =
  "Parse a valid JSON file. Available options:"

let print_res res () =
  match res with
  | None -> print_endline "Got None"
  | Some (Parser.Ok json, _) -> print_endline @@ Json.string_of_json json
  | Some (Parser.Error e, _) -> Printf.printf "Got error: %s\n" e

let main_helper () =
  match !file_name with
  | "" ->
    Printf.printf "Parsing JSON from STDIN\n";
    if !verbose
    then parse_in_chan stdin |> time |> print_res |> time |> ignore
    else parse_in_chan stdin |> time |> ignore
  | file ->
    Printf.printf "Parsing JSON from the file %s\n" file;
    if !verbose
    then parse_file file |> time |> print_res |> time |> ignore
    else parse_file file |> time |> ignore

let () =
  Arg.parse speclist
    (fun anon -> file_name := anon)
    usage_msg ;
  if !ask_help
  then Arg.usage speclist usage_msg
  else main_helper ()
