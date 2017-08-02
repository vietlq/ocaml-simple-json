#!/bin/bash -x

ocamlc -g -o test_json_parser \
    json.cmo lexer.cmo parser.cmo test_json_parser.ml \
    && ocamldebug ./test_json_parser
