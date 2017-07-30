.PHONY: all clean token json lexer parser test
.PHONY: build_parser debug_parser

all:
	ocamlopt -c token.mli
	ocamlopt -c json.mli
	ocamlopt -c lexer.mli
	ocamlopt -c parser.mli
	make test | wc

test:
	./run_json_test.sh

debug_parser: build_parser
	ocamldebug ./test_json_parser.byte

build_parser: token json lexer parser
	ocamlc -g -o test_json_parser.byte token.cmo json.cmo lexer.cmo parser.cmo \
		test_json_parser.ml

clean:
	rm -rf *.o *.cmi *.cmx *.cmo *.byte *.native *.cma *.cmxa

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
