
val lex : char Stream.t -> (Token.token * char Stream.t) option
(** A simple Lexer interface that takes a stream of char and
    returns lexing results.
*)
