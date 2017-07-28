.PHONY: all clean bytecode native debug test

OCB=ocamlbuild

all: bytecode

# Byte code
bytecode:
	$(OCB) -use-ocamlfind -pkgs cohttp.lwt http_client_01.byte | cat
	#ocamlc -g -thread -o $@ unix.cma threads.cma lwt.cma $<
	$(OCB) -use-ocamlfind -pkgs threads basic_echo_server.byte | cat

# Native
native:
	$(OCB) -use-ocamlfind -pkgs cohttp.lwt http_client_01.native | cat
	#ocamlopt -g -thread -o $@ unix.cmxa threads.cmxa lwt.cmxa $<
	$(OCB) -use-ocamlfind -pkgs threads basic_echo_server.native | cat

debug: bytecode
	ocamldebug http_client_01.byte

test: bytecode
	./http_client_01.byte

clean:
	$(OCB) -clean
	rm -rf *.o *.a *.lib
	rm -rf *.cmi *.cmx *.cma *.cmxa *.cmo *.exe
	rm -rf *.byte *.native _build
