# Pending OCaml service errors


## Reproduce the errors

```
Inside one window:
$ ./serv_up.exe 3000

In another window:
$ telnet 127.0.0.1 3000 < /usr/share/dict/words
```

Possible outcomes on the server side:

This isn't followed by a crash:

```
Sys_error: Protocol wrong type for socket
```

This is followed by a crash:

```
Got SIGPIPE!
Sys_error: Broken pipe
./serv_up.exe: "accept" failed: Interrupted system call
```

## Debug

First build with debug info:

```
$ ocamlc -g -thread -o serv_up.exe unix.cma threads.cma serv_up.ml
```

The launch the task via the ocamldebug

```
$ ocamldebug ./serv_up.exe 3000

(ocd) run
```

Repeat the process above using telnet and check the debugger:

```
Loading program... done.
Got SIGPIPE!
/Users/vietlq/projects/ocaml-json/./serv_up.exe: "accept" failed: Interrupted system call
Time: 5500 - pc: 172832 - module Serv_up
82   | Sys_error s -> <|b|>Printf.eprintf "Sys_error: %s\n" s; flush stderr
```
