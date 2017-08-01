type json_object = (string * value) list
and array = value list
and value =
    JsonObject of json_object
  | JsonArray of array
  | JsonString of string
  | JsonInt of Int64.t
  | JsonFloat of float
  | JsonBool of bool
  | JsonNull
val string_of_json : value -> string
