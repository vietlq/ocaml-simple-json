let parse_in_chan in_chan () =
  Parser.parse_top_level @@ Lexer.lex @@ Stream.of_channel @@ in_chan

let parse_file file () =
  parse_in_chan @@ open_in file

let time f =
  let t = Sys.time () in
  let _ = f () in
  Printf.printf "\nExecution time: %fs\n" (Sys.time() -. t)

let usage () =
  Printf.printf "1) Run: %s < input.json\n" Sys.argv.(0) ;
  Printf.printf "2) Run: %s input.json\n" Sys.argv.(0)

let () =
  match Array.length Sys.argv with
  | 1 ->
    Printf.printf "Parsing JSON from STDIN\n";
    time @@ parse_in_chan stdin
  | 2 ->
    let file = Sys.argv.(1) in
    Printf.printf "Parsing JSON from the file %s\n" file;
    time @@ parse_file file
  | _ -> usage ()
