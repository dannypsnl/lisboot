type program = expr list
and var = string
and expr =
  | Int of int
  | Bool of bool
  | Var of var
  (* (fn args ...) *)
  | App of expr * expr list
  (* (lambda (x y z ...) body) *)
  | Lam of var list * expr
  (* (define x t) *)
  | Define of var * expr
