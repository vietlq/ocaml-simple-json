.PHONY: all clean

OCB=ocamlbuild

all:
	$(OCB) test_json_lexer.native
	$(OCB) test_json_parser1.native
	$(OCB) test_json_parser2.native

clean:
	$(OCB) -clean
	rm -rf *.o *.a *.lib
	rm -rf *.cmi *.cmx *.cma *.cmxa *.cmo *.exe
	rm -rf *.byte *.native _build
