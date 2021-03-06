#!/bin/bash -x

function check_json()
{
    path=data/jsonchecker
    for test in $(echo ${path}/*.json)
    do
        ./json_checker ${test};
    done
}

ocamlopt -p -ccopt -O2 -ccopt -fno-omit-frame-pointer -o json_checker \
    json.cmx lexer.cmx parser.cmx json_checker.ml \
    && echo Running JSON Checker: \
    && check_json
