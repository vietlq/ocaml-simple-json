#!/bin/bash -x

ocamlopt -p -ccopt -O2 -ccopt -fno-omit-frame-pointer -o test_json_parser \
    json.ml lexer.ml parser.ml test_json_parser.ml \
    && time gunzip < test_medium.json.gz | ./test_json_parser
