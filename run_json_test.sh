#!/bin/bash -x

ocamlopt -O2 -o test_json_parser json.ml lexer.ml parser.ml test_json_parser.ml \
    && time gunzip < test_medium.json.gz | ./test_json_parser
