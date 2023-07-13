%{
open Ast
%}

%token EOF
%token <string> IDENTIFIER
%token <int> INT
%token <bool> BOOL
// keyword or symbol
%token DEFINE
%token LAMBDA
%token L_PAREN
%token R_PAREN

%type <Ast.program> program
%start program

%%

program:
  | expr* EOF { $1 }
  ;

expr:
    // (define x t)
  | L_PAREN DEFINE x=IDENTIFIER t=expr R_PAREN
    { Define (x, t) }
    // (lambda (x y z) t)
  | L_PAREN LAMBDA xs=IDENTIFIER* body=expr R_PAREN { Lam (xs, body) }
    // (fn args ...)
  | L_PAREN fn=expr args=expr* R_PAREN { App (fn, args) }
  | v=IDENTIFIER { Var v }
  | i=INT { Int i }
  | b=BOOL { Bool b }
  ;
