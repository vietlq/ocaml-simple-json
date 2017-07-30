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

let make_lazy_list t stream = LazyList (t, fun () -> lex stream) ;;

let stream_of_token t = Stream.from (fun acc -> Some t) ;;

let ret_val t stream = (stream_of_token t, stream) ;;

let lex stream =
  let rec aux stream acc =
    match Stream.peek stream with
    (* The end of stream *)
    | None -> (Stream.from (fun acc -> None), stream)
    | Some c -> begin
      Stream.junk stream;
      match c with
      (* Ignore white spaces *)
      | ' ' | '\t' | '\n' | '\r' -> aux stream (acc+1)
      (* Important characters *)
      | '{' -> ret_val T_OBJ_BEGIN stream
      | '}' -> ret_val T_OBJ_END stream
      | '[' -> ret_val T_ARR_BEGIN stream
      | ']' -> ret_val T_ARR_END stream
      | ':' -> ret_val T_COLON stream
      | ',' -> ret_val T_COMMA stream
      | _ -> aux stream (acc+1)
    end
  in aux stream 0
;;

let in_chan = Stream.of_channel stdin ;;

let y = lex in_chan ;;
