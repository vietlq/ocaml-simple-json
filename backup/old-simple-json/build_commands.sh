ocamldep.opt -modules test_json_lexer.ml > test_json_lexer.ml.depends
ocamldep.opt -pp camlp4of -modules lexer.ml > lexer.ml.depends
ocamldep.opt -modules token.ml > token.ml.depends
ocamlc.opt -c -o token.cmo token.ml
ocamlc.opt -c -I /usr/local/lib/ocaml/camlp4 -pp camlp4of -o lexer.cmo lexer.ml
ocamlc.opt -c -o test_json_lexer.cmo test_json_lexer.ml
ocamlopt.opt -c -o token.cmx token.ml
ocamlopt.opt -c -I /usr/local/lib/ocaml/camlp4 -pp camlp4of -o lexer.cmx lexer.ml
ocamlopt.opt -c -o test_json_lexer.cmx test_json_lexer.ml
ocamlopt.opt token.cmx lexer.cmx test_json_lexer.cmx -o test_json_lexer.native
ocamldep.opt -modules test_json_parser1.ml > test_json_parser1.ml.depends
ocamldep.opt -modules json.ml > json.ml.depends
ocamldep.opt -pp camlp4of -modules parser1.ml > parser1.ml.depends
ocamlc.opt -c -o json.cmo json.ml
ocamlc.opt -c -I /usr/local/lib/ocaml/camlp4 -pp camlp4of -o parser1.cmo parser1.ml
ocamlc.opt -c -o test_json_parser1.cmo test_json_parser1.ml
ocamlopt.opt -c -o json.cmx json.ml
ocamlopt.opt -c -I /usr/local/lib/ocaml/camlp4 -pp camlp4of -o parser1.cmx parser1.ml
ocamlopt.opt -c -o test_json_parser1.cmx test_json_parser1.ml
ocamlopt.opt json.cmx token.cmx lexer.cmx parser1.cmx test_json_parser1.cmx -o test_json_parser1.native
ocamldep.opt -modules test_json_parser2.ml > test_json_parser2.ml.depends
ocamldep.opt -pp camlp4of -modules parser2.ml > parser2.ml.depends
ocamlc.opt -c -I /usr/local/lib/ocaml/camlp4 -pp camlp4of -o parser2.cmo parser2.ml
ocamlc.opt -c -o test_json_parser2.cmo test_json_parser2.ml
ocamlopt.opt -c -I /usr/local/lib/ocaml/camlp4 -pp camlp4of -o parser2.cmx parser2.ml
ocamlopt.opt -c -o test_json_parser2.cmx test_json_parser2.ml
ocamlopt.opt json.cmx token.cmx lexer.cmx parser2.cmx test_json_parser2.cmx -o test_json_parser2.native
