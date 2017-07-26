.PHONY: all clean bytecode native debug test

OCB=ocamlbuild

all: bytecode

# Byte code
bytecode: http_client_01.ml
	$(OCB) -use-ocamlfind -pkgs cohttp.lwt http_client_01.byte | cat
	#ocamlc -g -thread -o $@ unix.cma threads.cma lwt.cma $<

# Native
native: http_client_01.ml
	$(OCB) -use-ocamlfind -pkgs cohttp.lwt http_client_01.native | cat
	#ocamlopt -g -thread -o $@ unix.cmxa threads.cmxa lwt.cmxa $<

debug: bytecode
	ocamldebug http_client_01.byte

test: bytecode
	./http_client_01.byte

clean:
	$(OCB) -clean
	rm -rf *.o *.a *.lib
	rm -rf *.cmi *.cmx *.cma *.cmxa *.cmo *.exe
	rm -rf *.byte *.native _build
