(*
  Version 1 of JSON parser using camlp4.
  No error recovery provided.
  It only accepts first JSON object/array in the stream.
*)

let rec parse_value = parser
  | [< obj=parse_object >] -> [< 'obj >]
  | [< arr=parse_array >] -> [< 'arr >]
  | [< json=parse_primary >] -> [< 'json >]
  | [< >] -> [< >]

and parse_json_string = parser
  | [< 'Token.T_STRING strVal >] -> Json.JsonString strVal

and parse_json_number = parser
  | [< 'Token.T_NUMBER number >] -> Json.JsonNumber number

and parse_json_bool = parser
  | [< 'Token.T_TRUE >] -> Json.JsonBool true
  | [< 'Token.T_FALSE >] -> Json.JsonBool false

and parse_json_null = parser
  | [< 'Token.T_NULL >] -> Json.JsonNull

and parse_primary = parser
  | [< json=parse_json_string >] -> json
  | [< json=parse_json_number >] -> json
  | [< json=parse_json_bool >] -> json
  | [< json=parse_json_null >] -> json

and parse_array = parser
  | [< 'Token.T_ARR_BEGIN; stream >] ->
    let rec parse_array_part accumulator = parser
      | [< 'Token.T_ARR_END >] ->
        Json.JsonArray accumulator
      | [< 'Token.T_COMMA; stream >] ->
        let json_stream = parse_value stream in
        begin
          match Stream.peek json_stream with
          | None -> raise (Stream.Error "Expected a JSON value in the array (1).")
          | Some json ->
            begin
              match accumulator with
              | x :: _ -> parse_array_part (json::accumulator) stream
              | [] -> raise (Stream.Error "Expected a JSON value before the T_COMMA.")
            end
        end
      | [< stream >] ->
        let json_stream = parse_value stream in
        begin
          match Stream.peek json_stream with
          | None -> raise (Stream.Error "Expected a JSON value in the array (2).")
          | Some json ->
            begin
              match accumulator with
              | x :: _ -> raise (Stream.Error "Expected T_COMMA before the JSON value.")
              | [] -> parse_array_part (json :: accumulator) stream
            end
        end
      | [< >] -> raise (Stream.Error "Expected ].")
    in parse_array_part [] stream

and parse_object_pair = parser
  | [< 'Token.T_STRING key; 'Token.T_COLON; stream >] ->
    let json_stream = parse_value stream in
    begin
      match Stream.peek json_stream with
      | None -> raise (Stream.Error "Expected a JSON value in the object pair.")
      | Some value -> (key, value)
    end

and parse_object = parser
  | [< 'Token.T_OBJ_BEGIN; stream >] ->
    let rec parse_object_part accumulator = parser
      | [< 'Token.T_OBJ_END >] ->
        Json.JsonObject accumulator
      | [< 'Token.T_COMMA; pair=parse_object_pair; stream >] ->
        begin
          match accumulator with
          | x :: _ -> parse_object_part (pair :: accumulator) stream
          | [] -> raise (Stream.Error "Expected a JSON pair before the T_COMMA.")
        end
      | [< pair=parse_object_pair; stream >] ->
        begin
          match accumulator with
          | x :: _ -> raise (Stream.Error "Expected T_COMMA before the JSON pair.")
          | [] -> parse_object_part (pair :: accumulator) stream
        end
      | [< >] -> raise (Stream.Error "Expected }.")
    in parse_object_part [] stream

and parse_top_level = parser
  | [< stream >] ->
    begin
      match Stream.peek stream with
      | None -> [< >]
      | Some Token.T_OBJ_BEGIN | Some Token.T_ARR_BEGIN ->
        begin
          let value = parse_value stream in
          match Stream.peek stream with
          | None -> value
          | Some _ ->
            raise (Stream.Error "The top-level JSON must contain a single object/array.")
        end
      | Some _ ->
        raise (Stream.Error "The top-level JSON value must be an object or an array.")
    end
