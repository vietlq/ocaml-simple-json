#!/bin/bash -x

ocamlopt -p -ccopt -O2 -ccopt -fno-omit-frame-pointer -o test_json_parser \
    json.cmx lexer.cmx parser.cmx test_json_parser.ml \
    && time gunzip < data/test_medium.json.gz | ./test_json_parser
