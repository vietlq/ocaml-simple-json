type ('a, 'b) result =
  | Ok of 'a
  | Error of 'b

exception Bad_syntax of string

let rec parse_value lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_OBJ_BEGIN, stream) -> parse_object lex_res
  | Some (Token.T_ARR_BEGIN, stream) -> parse_array lex_res
  | _ -> parse_primary lex_res

and parse_json_string lex_res =
  match lex_res with
  | Some (Token.T_STRING strVal, stream) -> Some (Ok (Json.JsonString strVal), stream)
  | _ -> raise (Bad_syntax (Printf.sprintf "Bad: %s" __LOC__))

and parse_json_number lex_res =
  match lex_res with
  | Some (Token.T_NUMBER number, stream) -> Some (Ok (Json.JsonNumber number), stream)
  | _ -> raise (Bad_syntax (Printf.sprintf "Bad: %s" __LOC__))

and parse_json_bool lex_res =
  match lex_res with
  | Some (Token.T_TRUE, stream) -> Some (Ok (Json.JsonBool true), stream)
  | Some (Token.T_FALSE, stream) -> Some (Ok (Json.JsonBool false), stream)
  | _ -> raise (Bad_syntax (Printf.sprintf "Bad: %s" __LOC__))

and parse_json_null lex_res =
  match lex_res with
  | Some (Token.T_NULL, stream) -> Some (Ok (Json.JsonNull), stream)
  | _ -> raise (Bad_syntax (Printf.sprintf "Bad: %s" __LOC__))

and parse_primary lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_STRING _, stream) -> parse_json_string @@ Lexer.lex stream
  | Some (Token.T_NUMBER _, stream) -> parse_json_number @@ Lexer.lex stream
  | Some (Token.T_TRUE, stream) -> parse_json_bool @@ Lexer.lex stream
  | Some (Token.T_FALSE, stream) -> parse_json_bool @@ Lexer.lex stream
  | Some (Token.T_NULL, stream) -> parse_json_null @@ Lexer.lex stream
  | _ -> Printexc.print_backtrace stdout ;
    raise (Bad_syntax (Printf.sprintf "Bad: %s" __LOC__))

and parse_array lex_res =
  match lex_res with
  | Some (Token.T_ARR_BEGIN, stream) ->
    begin
      let rec parse_array_part accumulator lex_res =
        match Lexer.lex stream with
        | None -> raise (Stream.Error "Expected ].")
        | Some (Token.T_ARR_END, stream) ->
          Some (Ok (Json.JsonArray accumulator), stream)
        | Some (Token.T_COMMA, stream) ->
          begin
            match parse_json_string @@ Lexer.lex stream with
            | None -> Some (Error "Expected a JSON value in the array (1).", stream)
            | Some (Ok (json : Json.value), stream) ->
              begin
                match accumulator with
                | x :: _ -> parse_array_part (json :: accumulator) (Lexer.lex stream)
                | [] -> Some (Error "Expected a JSON value before the T_COMMA.", stream)
              end
            | _ -> raise (Bad_syntax (Printf.sprintf "Bad: %s" __LOC__))
          end
        | Some (_, stream) ->
          begin
            match parse_value @@ Lexer.lex stream with
            | None -> Some (Error "Expected a JSON value in the array (2).", stream)
            | Some (Error e, stream) -> Some (Error e, stream)
            | Some (Ok (json : Json.value), stream) ->
              begin
                match accumulator with
                | x :: _ -> Some (Error "Expected T_COMMA before the JSON value.", stream)
                | [] -> parse_array_part (json :: accumulator) (Lexer.lex stream)
              end
          end
      in parse_array_part [] (Lexer.lex stream)
    end
  | _ -> raise (Bad_syntax (Printf.sprintf "Bad: %s" __LOC__))

and parse_object_pair lex_res =
  match lex_res with
  | Some (Token.T_STRING key, stream) ->
    begin
      match Lexer.lex stream with
      | None -> raise (Bad_syntax (Printf.sprintf "Bad: %s" __LOC__))
      | Some (Token.T_COLON, stream) ->
        begin
          match parse_value @@ Lexer.lex stream with
          | None -> raise (Stream.Error "Expected a JSON value in the object pair.")
          | Some (Error e, stream) -> raise (Stream.Error e)
          | Some (Ok (value : Json.value), stream) -> ((key, value), stream)
        end
      | _ -> raise (Bad_syntax (Printf.sprintf "Bad: %s" __LOC__))
    end
  | _ -> raise (Bad_syntax (Printf.sprintf "Bad: %s" __LOC__))

and parse_object lex_res =
  match lex_res with
  | Some (Token.T_OBJ_BEGIN, stream) ->
    begin
      let rec parse_object_part accumulator lex_res =
        match lex_res with
        | None -> raise (Stream.Error "Expected }.")
        | Some (Token.T_OBJ_END, _) ->
          Ok (Json.JsonObject accumulator)
        | Some (Token.T_COMMA, stream) ->
          let (pair, stream) = parse_object_pair @@ Lexer.lex stream in
          begin
            match accumulator with
            | x :: _ -> parse_object_part (pair :: accumulator) (Lexer.lex stream)
            | [] -> Error "Expected a JSON pair before the T_COMMA."
          end
        | Some (_, stream) ->
          let (pair, stream) = parse_object_pair @@ Lexer.lex stream in
          begin
            match accumulator with
            | x :: _ -> Error "Expected T_COMMA before the JSON pair."
            | [] -> parse_object_part (pair :: accumulator) (Lexer.lex stream)
          end
      in let res = parse_object_part [] (Lexer.lex stream)
      in Some (res, stream)
    end
  | _ -> raise (Bad_syntax (Printf.sprintf "Bad: %s" __LOC__))

and parse_top_level lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_OBJ_BEGIN, stream) -> parse_value @@ Lexer.lex stream
  | Some (Token.T_ARR_BEGIN, stream) -> parse_value @@ Lexer.lex stream
  | Some (_, stream) ->
    let err = "The top-level JSON value must be an object or an array." in
    Some (Error err, stream)
