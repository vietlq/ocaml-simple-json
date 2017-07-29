type token =
    T_OBJ_BEGIN
  | T_OBJ_END
  | T_ARR_BEGIN
  | T_ARR_END
  | T_COLON
  | T_COMMA
  | T_STRING of string
  | T_NUMBER of float
  | T_TRUE
  | T_FALSE
  | T_NULL
;;

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
