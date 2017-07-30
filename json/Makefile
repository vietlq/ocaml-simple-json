.PHONY: all token json lexer parser test_parser test

all:
	ocamlopt -c token.mli
	ocamlopt -c json.mli
	ocamlopt -c lexer.mli
	ocamlopt -c parser.mli
	make test | wc

token:
	ocamlc -c token.mli
	ocamlc -c token.ml

json:
	ocamlc -c json.mli
	ocamlc -c json.ml

lexer:
	ocamlc -c lexer.mli
	ocamlc -c lexer.ml

parser:
	ocamlc -c parser.mli
	ocamlc -c parser.ml

test_parser:
	ocamlc -g -o test_json_parser token.cmo json.cmo lexer.cmo parser.cmo \
		test_json_parser.ml

test:
	./run_json_test.sh
