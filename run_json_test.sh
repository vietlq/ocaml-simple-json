#!/bin/bash -x

ocamlc -o test_json_parser json.ml lexer.ml parser.ml test_json_parser.ml

ocamldebug ./test_json_parser
