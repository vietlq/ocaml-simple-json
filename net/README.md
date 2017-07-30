# OCaml Lwt Training

Dependencies

```
opam update
opam upgrade
opam install Cohttp
opam install cohttp-lwt-unix
```

If you choose to build with `Oasis`, add in your `_oasis` file:

```
Executable "golfcaml"
  Path: src
  MainIs: golf.ml
  CompiledObject: best
  BuildDepends:
    str
```

When building with `ocamlfind`, use `-pkgs threads` so the Thread library is properly linked. The same applies if you use `ocamlfind` via `ocamlbuild`:

```
ocamlfind -pkgs threads abc.native
ocamlbuild -use-ocamlfind -pkgs threads abc.native
```

You can skip `ocamlfind` if your project is simple:

```
ocamlbuild abc.native
ocamlopt -o abc.native unix.cmxa threads.cmxa abc.ml
```

## References

https://opam.ocaml.org/doc/Packaging.html

https://stackoverflow.com/questions/16783056/ocamlbuild-and-packages-installed-via-opam

https://stackoverflow.com/questions/16552834/how-to-use-thread-compiler-flag-with-ocamlbuild

https://bitbucket.org/yminsky/core-hello-world/src/85769e337d3e70a4b9e3246503f59991c109afe8/_tags?at=default&fileviewer=file-view-default

https://stackoverflow.com/questions/38547815/no-implementations-provided-for-the-following-modules-str
