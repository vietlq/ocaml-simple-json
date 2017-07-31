type ('a, 'b) result =
  | Ok of 'a
  | Error of 'b

let rec parse_value lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_OBJ_BEGIN, stream) -> parse_object lex_res
  | Some (Token.T_ARR_BEGIN, stream) -> parse_array lex_res
  | _ -> parse_primary lex_res

and parse_json_string lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_STRING strVal, stream) ->
    Some (Ok (Json.JsonString strVal), stream)
  | Some (_, stream) -> Some (Error __LOC__, stream)

and parse_json_number lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_NUMBER number, stream) ->
    Some (Ok (Json.JsonNumber number), stream)
  | Some (_, stream) -> Some (Error __LOC__, stream)

and parse_json_bool lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_TRUE, stream) ->
    Some (Ok (Json.JsonBool true), stream)
  | Some (Token.T_FALSE, stream) ->
    Some (Ok (Json.JsonBool false), stream)
  | Some (_, stream) -> Some (Error __LOC__, stream)

and parse_json_null lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_NULL, stream) -> Some (Ok (Json.JsonNull), stream)
  | Some (_, stream) -> Some (Error __LOC__, stream)

and parse_primary lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_STRING _, stream) -> parse_json_string lex_res
  | Some (Token.T_NUMBER _, stream) -> parse_json_number lex_res
  | Some (Token.T_TRUE, stream) -> parse_json_bool lex_res
  | Some (Token.T_FALSE, stream) -> parse_json_bool lex_res
  | Some (Token.T_NULL, stream) -> parse_json_null lex_res
  | Some (_, stream) -> Some (Error __LOC__, stream)

and parse_array lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_ARR_BEGIN, stream) ->
    begin
      let rec parse_array_part accumulator lex_res =
        match lex_res with
        | None -> raise (Stream.Error "Expected ].")
        | Some (Token.T_ARR_END, stream) ->
          Some (Ok (Json.JsonArray accumulator), stream)
        | Some (Token.T_COMMA, stream) ->
          begin
            match parse_value @@ Lexer.lex stream with
            | None ->
              Some (Error "Expected a JSON value in the array (1).", stream)
            | Some (Ok (json : Json.value), stream) ->
              begin
                match accumulator with
                | x :: _ ->
                  parse_array_part (json :: accumulator) (Lexer.lex stream)
                | [] ->
                  Some (Error "Expected a JSON value before the T_COMMA.", stream)
              end
            | Some (_, stream) ->
              let e =  "Expected a JSON value after T_COMMA in JSON Array"
              in Some (Error e, stream)
          end
        | Some (_, _) as new_lex_res ->
          match parse_value new_lex_res with
          | None ->
            Some (Error "Expected a JSON value in the array (2).", stream)
          | Some (Error e, stream) -> Some (Error e, stream)
          | Some (Ok (json : Json.value), stream) ->
            begin
              match accumulator with
              | x :: _ ->
                Some (Error "Expected T_COMMA before the JSON value.", stream)
              | [] ->
                parse_array_part (json :: accumulator) (Lexer.lex stream)
            end
      in try
        match Lexer.lex stream with
        | None -> Some (Error "Expected T_ARR_END", stream)
        | Some (_, _) as new_lex_res ->
          parse_array_part [] new_lex_res
      with
      | Failure s -> Some (Error s, stream)
      | Stream.Failure -> Some (Error "Expected T_ARR_END", stream)
      | Stream.Error s -> Some (Error s, stream)
    end
  | Some (_, stream) -> Some (Error __LOC__, stream)

and parse_object_pair lex_res =
  match lex_res with
  | Some (Token.T_STRING key, stream) ->
    begin
      match Lexer.lex stream with
      | None -> raise (Stream.Error "Expected a T_COLON.")
      | Some (Token.T_COLON, stream) ->
        begin
          match parse_value @@ Lexer.lex stream with
          | None ->
            raise (Stream.Error "Expected a JSON value in the object pair.")
          | Some (Error e, stream) -> raise (Stream.Error e)
          | Some (Ok (value : Json.value), stream) -> ((key, value), stream)
        end
      | _ -> raise (Stream.Error "Expected a T_COLON.")
    end
  | _ ->
    let e = "Expected a T_OBJ_END '}' or T_STRING key for JSON object."
    in raise (Stream.Error e)

and parse_object lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_OBJ_BEGIN, stream) ->
    begin
      let rec parse_object_part accumulator lex_res =
        match lex_res with
        | None -> raise (Stream.Error "Expected }.")
        | Some (Token.T_OBJ_END, stream) ->
          Some (Ok (Json.JsonObject accumulator), stream)
        | Some (Token.T_COMMA, stream) ->
          let (pair, stream) = parse_object_pair @@ Lexer.lex stream in
          begin
            match accumulator with
            | x :: _ ->
              parse_object_part (pair :: accumulator) (Lexer.lex stream)
            | [] ->
              Some (Error "Expected a JSON pair before T_COMMA.", stream)
          end
        | Some (Token.T_STRING _, _) as new_lex_res ->
          let (pair, stream) = parse_object_pair new_lex_res in
          begin
            match accumulator with
            | x :: _ ->
              Some (Error "Expected T_COMMA before the JSON pair.", stream)
            | [] ->
              parse_object_part (pair :: accumulator) (Lexer.lex stream)
          end
        | Some (_, stream) -> Some (Error __LOC__, stream)
      in try
        match Lexer.lex stream with
        | None -> Some (Error "Expected T_OBJ_END", stream)
        | Some (_, _) as new_lex_res ->
          parse_object_part [] new_lex_res
      with
      | Failure s -> Some (Error s, stream)
      | Stream.Failure -> Some (Error "Expected T_OBJ_END", stream)
      | Stream.Error s -> Some (Error s, stream)
    end
  | Some (_, stream) -> Some (Error __LOC__, stream)

and parse_top_level lex_res =
  match lex_res with
  | None -> None
  | Some (Token.T_OBJ_BEGIN, stream) -> parse_value lex_res
  | Some (Token.T_ARR_BEGIN, stream) -> parse_value lex_res
  | Some (_, stream) ->
    let err = "The top-level JSON value must be an object or an array." in
    Some (Error err, stream)
