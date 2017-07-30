let parse_in_chan in_chan () =
  Parser.parse_top_level @@ Lexer.lex @@ Stream.of_channel @@ in_chan

let parse_file file () =
  parse_in_chan (open_in file) ()

let time f =
  let t = Sys.time () in
  let res = f () in
  Printf.printf "\nExecution time: %fs\n" (Sys.time() -. t) ;
  res

let usage () =
  Printf.printf "1) Run: %s < input.json\n" Sys.argv.(0) ;
  Printf.printf "2) Run: %s input.json\n" Sys.argv.(0)

let print_res res () =
  match res with
  | None -> print_endline "Got None"
  | Some (Parser.Ok json, _) -> print_endline @@ Json.string_of_json json
  | Some (Parser.Error e, _) -> Printf.printf "Got error: %s\n" e

let () =
  match Array.length Sys.argv with
  | 1 ->
    Printf.printf "Parsing JSON from STDIN\n";
    (* parse_in_chan stdin |> time |> print_res |> time |> ignore *)
    parse_in_chan stdin |> time |> ignore
  | 2 ->
    let file = Sys.argv.(1) in
    Printf.printf "Parsing JSON from the file %s\n" file;
    (* parse_file file |> time |> print_res |> time |> ignore *)
    parse_file file |> time |> ignore
  | _ -> usage ()
