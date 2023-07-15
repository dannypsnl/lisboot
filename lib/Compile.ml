open Ast
open List

exception TODO

let rec compile : program -> out_channel -> unit =
 fun prog out ->
  (* 先編譯定義出來 *)
  iter (fun e -> output_string out (compile_define e)) prog;
  (* 把其他表達式編譯到 scheme_expr，每支模組都有這樣的 entry point *)
  output_string out "fn scheme_expr() {\n";
  iter (fun e -> output_string out (compile_expr e)) prog;
  output_string out "\n}"

and compile_define : expr -> string =
 fun e ->
  match e with
  | Define (x, e) -> "const " ^ x ^ " = " ^ compile_expr e ^ ";\n"
  | _ -> ""

and compile_expr : expr -> string =
 fun e ->
  match e with
  | Var x -> x
  | Int i -> string_of_int i
  | Bool b -> string_of_bool b
  | App (Var "+", args) ->
      fold_left
        (fun l r -> l ^ "+" ^ compile_expr r)
        (compile_expr (hd args))
        (tl args)
  | App (Var "-", args) ->
      fold_left
        (fun l r -> l ^ "-" ^ compile_expr r)
        (compile_expr (hd args))
        (tl args)
  | App (_fn, _args) -> raise TODO
  | Lam (_, _) -> raise TODO
  | Define _ -> ""
