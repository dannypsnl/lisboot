build_compiler:
	@dune build
.PHONY: build_compiler

run_example: build_compiler
	./_build/default/bin/main.exe example/test.ss
	clang runtime/scheme.c _build/output.exe.c _build/output.lib.c
	./a.out
.PHONY: run_example
