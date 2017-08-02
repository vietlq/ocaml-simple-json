(**
    JSON types and operations.
*)

(** JSON Object *)
type json_object = (string * value) list

(** JSON Array *)
and array = value list

(** JSON Values. Note: Custom handling of integers. *)
and value =
    JsonObject of json_object
  | JsonArray of array
  | JsonString of string
  | JsonInt of Int64.t
  | JsonFloat of float
  | JsonBool of bool
  | JsonNull

val string_of_json : value -> string
(** Convert a JSON [value] to a condensed [string] *)
