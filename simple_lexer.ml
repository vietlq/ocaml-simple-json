let rec lex stream =
  match Stream.peek stream with
  (* The end of stream *)
  | None -> Stream.from (fun n -> Printf.printf "Count = %d" n ; None)
  | Some c -> begin
    match c with
    (* Ignore white spaces *)
    | ' ' | '\t' | '\n' | '\r' -> Stream.junk stream; lex stream
    (* Important characters *)
    | '{' -> Stream.from (fun n -> Printf.printf "Count = %d" n ; Some T_OBJ_BEGIN)
    | '}' -> Stream.from (fun n -> Printf.printf "Count = %d" n ; Some T_OBJ_END)
    | '[' -> Stream.from (fun n -> Printf.printf "Count = %d" n ; Some T_ARR_BEGIN)
    | ']' -> Stream.from (fun n -> Printf.printf "Count = %d" n ; Some T_ARR_END)
    | ':' -> Stream.from (fun n -> Printf.printf "Count = %d" n ; Some T_COLON)
    | ',' -> Stream.from (fun n -> Printf.printf "Count = %d" n ; Some T_COMMA)
    | _ -> Stream.junk stream; lex stream
  end
;;

let in_chan = Stream.of_channel stdin ;;

let y = lex in_chan ;;
