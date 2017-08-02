.PHONY: all clean token json lexer parser test
.PHONY: build_parser debug_parser interfaces time_test
.PHONY: build_basics docs

all: interfaces build_basics build_parser
	make test | wc
	make time_test

build_basics:
	ocamlopt -c token.ml
	ocamlopt -c json.ml
	ocamlopt -c lexer.ml
	ocamlopt -c parser.ml
	ocamlc -c token.ml
	ocamlc -c json.ml
	ocamlc -c lexer.ml
	ocamlc -c parser.ml

test: interfaces
	./run_json_test.sh

time_test: interfaces
	./run_time_test.sh

debug_parser: build_parser
	ocamldebug ./test_json_parser.byte

build_parser: token json lexer parser
	ocamlc -g -o test_json_parser.byte token.cmo json.cmo lexer.cmo parser.cmo \
		test_json_parser.ml

clean:
	rm -rf *.o *.cmi *.cmx *.cmo *.byte *.native *.cma *.cmxa

interfaces:
	ocamlopt -c token.mli
	ocamlopt -c json.mli
	ocamlopt -c lexer.mli
	ocamlopt -c parser.mli

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

docs:
	ocamldoc -html *.mli -d docs/
