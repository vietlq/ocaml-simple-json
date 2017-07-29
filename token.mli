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
