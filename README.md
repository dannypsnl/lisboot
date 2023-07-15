# lisboot

This project shows a trick to compile scripting language. The definition of scripting language here means, you can run any file of such language to get some print out, no explicit entry point is written done.

With this definition, a program file `hello.ss` with content below

```scm
(define x 1)
(define y 2)
x+y
```

get `3` printed by command `scheme hello.ss`. If another program `wow.ss` import it, `hello.ss` then became a library, but `3` won't get printed. This is a design choice, you can also let that get printed by invoke module's entry point, that will not affect the trick I'm going to explain.

## Explaination

To compile out such result, a file get compiled to two parts:

1. definition
2. entry

So `hello.ss` became `hello.lib.c`

```c
int x = 1;
int y = 2;
```

and `hello.entry.c`

```c
void entry() {
  extern int x;
  extern int y;
  printf("%d", x + y);
}
```

If I type command `scheme hello.ss`, then lower command can be

```shell
clang runtime/scheme.c hello.lib.c hello.entry.c
./a.out
```

If I type `scheme wow.ss`, then it's actually

```shell
clang runtime/scheme.c hello.lib.c wow.lib.c wow.entry.c
./a.out
```

### Something you need to know about the implementation

In this implementation, I only put integer as expression into the compiler, so there has no runtime value supporting needed. Except that, I also didn't really implement module import feature, but the explaination already points out how does it actually work.

Of course, these make our program less practical, but also help us more focus on only linking problem for purpose. This repository is more like a good start point, you setup your project from here, and add more features.

## Must define first?

If one think a definition can be access from any part of file, they can compile code to

```c
extern int x;
extern int y;

void entry() {
  printf("%d", x + y);
}
```

This is, also a design choice.
