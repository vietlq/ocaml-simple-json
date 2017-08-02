(**
    Lexer interface produces tokens from a stream of char.
*)

val lex : char Stream.t -> (Token.token * char Stream.t) option
(** Lexer takes a stream of char and returns lexing results. *)
