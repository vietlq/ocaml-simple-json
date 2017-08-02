(** Lexer tokens. *)

(** Lexer tokens. Note: Custom handling of integer values *)
type token =
    T_OBJ_BEGIN
  | T_OBJ_END
  | T_ARR_BEGIN
  | T_ARR_END
  | T_COLON
  | T_COMMA
  | T_STRING of string
  | T_NUM_INT of Int64.t
  | T_NUM_FP of float
  | T_TRUE
  | T_FALSE
  | T_NULL
