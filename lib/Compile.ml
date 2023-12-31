open Ast
open List

exception TODO
exception Skip
exception Decl of string

let rec compile : program -> out_channel -> out_channel -> unit =
 fun prog lib_out exe_out ->
  (* 編譯定義到 library *)
  iter
    (fun e -> try output_string lib_out (compile_define e) with Skip -> ())
    prog;
  (* 把其他表達式編譯到 scheme_entry，每支模組都有這樣的 entry point *)
  output_string exe_out "#include <stdio.h>\n";
  output_string exe_out "void scheme_entry() {\n";
  iter
    (fun e ->
      try output_string exe_out ("printf(\"%d\\n\", " ^ compile_expr e ^ ");")
      with Decl res -> output_string exe_out res)
    prog;
  output_string exe_out "\n}"

and compile_define : expr -> string =
 fun e ->
  match e with
  | Define (x, e) -> "int " ^ x ^ " = " ^ compile_expr e ^ ";\n"
  | _ -> raise Skip

and compile_expr : expr -> string =
 fun e ->
  match e with
  | Var x -> x
  | Int i -> string_of_int i
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
  (* we don't take care general application here since the trick demonstration is complete *)
  | App (_fn, _args) -> raise TODO
  (* 編譯定義的宣告 *)
  | Define (x, _) -> raise (Decl ("extern int " ^ x ^ ";\n"))
