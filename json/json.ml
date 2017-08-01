type json_object = (string * value) list

and array = value list

and value =
  | JsonObject of json_object
  | JsonArray of array
  | JsonString of string
  | JsonInt of Int64.t
  | JsonFloat of float
  | JsonBool of bool
  | JsonNull

let rec string_of_json json_value =
  match json_value with
  | JsonObject obj ->
    begin
      let string_of_obj_pairs pairs =
        let pairs = List.rev_map (fun (key, value) ->
          Printf.sprintf "\"%s\":%s"
            (String.escaped key)
            (string_of_json value)) pairs
        in
        String.concat "," pairs
      in Printf.sprintf "{%s}" (string_of_obj_pairs obj)
    end
  | JsonArray arr ->
    begin
      let string_of_arr_items items =
        let items = List.rev_map string_of_json items in
        String.concat "," items
      in Printf.sprintf "[%s]" (string_of_arr_items arr)
    end
  | JsonString s -> Printf.sprintf "\"%s\"" (String.escaped s)
  | JsonInt n -> Int64.to_string n
  | JsonFloat n -> string_of_float n
  | JsonBool b -> (match b with
      | true -> "true"
      | _ -> "false")
  | JsonNull -> "null"
