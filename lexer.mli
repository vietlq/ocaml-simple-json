val lex : char Stream.t -> (Token.token * char Stream.t) option
val lex_string :
  Buffer.t -> char Stream.t -> (Token.token * char Stream.t) option
val lex_number :
  Buffer.t -> char Stream.t -> (Token.token * char Stream.t) option
val lex_tfn :
  Buffer.t -> char Stream.t -> (Token.token * char Stream.t) option
