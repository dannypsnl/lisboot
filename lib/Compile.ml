open Ast

exception TODO

let rec compile : program -> out_channel -> unit = 
  fun prog out ->
    List.iter
      (fun e -> output_string out (compile_each e))
      prog
and compile_each : expr -> string =
  fun e -> 
    match e with
    | Var x -> x
    | _ -> raise TODO
