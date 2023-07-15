%{
open Ast
%}

%token EOF
%token <string> IDENTIFIER
%token <int> INT
// keyword or symbol
%token DEFINE
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
    // (fn args ...)
  | L_PAREN fn=expr args=expr* R_PAREN { App (fn, args) }
  | v=IDENTIFIER { Var v }
  | i=INT { Int i }
  ;
