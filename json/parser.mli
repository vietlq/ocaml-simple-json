(**
    Parser interface produces JSON values from lexer tokens.
*)

(** Return variant type: [Ok] for good operations and [Error] for errors *)
type ('a, 'b) result =
    Ok of 'a
  | Error of 'b

val parse_top_level :
  (Token.token * char Stream.t) option ->
  ((Json.value, string) result * char Stream.t) option
(** Parse top level JSON values from tokens: Array or Object *)
