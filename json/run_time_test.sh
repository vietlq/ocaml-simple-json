#!/bin/bash -x

ocamlopt -p -ccopt -O2 -ccopt -fno-omit-frame-pointer -o time_test_json \
    json.cmx lexer.cmx parser.cmx time_test_json.ml \
    && ./time_test_json data/test_tiny.json \
    && ./time_test_json data/test_small.json \
    && echo Extracting data/test_medium.json.gz \
    && time gunzip < data/test_medium.json.gz | ./time_test_json
