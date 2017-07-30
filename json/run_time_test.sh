#!/bin/bash -x

ocamlopt -p -ccopt -O2 -ccopt -fno-omit-frame-pointer -o time_test_json \
    json.ml lexer.ml parser.ml time_test_json.ml \
    && ./time_test_json test_tiny.json \
    && ./time_test_json test_small.json \
    && echo Extracting test_medium.json.gz \
    && time gunzip < test_medium.json.gz | ./time_test_json
