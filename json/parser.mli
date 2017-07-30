type ('a, 'b) result = Ok of 'a | Error of 'b
val parse_value :
  (Token.token * char Stream.t) option ->
  ((Json.value, string) result * char Stream.t) option
val parse_json_string :
  (Token.token * char Stream.t) option ->
  ((Json.value, string) result * char Stream.t) option
val parse_json_number :
  (Token.token * char Stream.t) option ->
  ((Json.value, string) result * char Stream.t) option
val parse_json_bool :
  (Token.token * char Stream.t) option ->
  ((Json.value, string) result * char Stream.t) option
val parse_json_null :
  (Token.token * char Stream.t) option ->
  ((Json.value, string) result * char Stream.t) option
val parse_primary :
  (Token.token * char Stream.t) option ->
  ((Json.value, string) result * char Stream.t) option
val parse_array :
  (Token.token * char Stream.t) option ->
  ((Json.value, string) result * char Stream.t) option
val parse_object_pair :
  (Token.token * char Stream.t) option ->
  (string * Json.value) * char Stream.t
val parse_object :
  (Token.token * char Stream.t) option ->
  ((Json.value, string) result * char Stream.t) option
val parse_top_level :
  (Token.token * char Stream.t) option ->
  ((Json.value, string) result * char Stream.t) option
