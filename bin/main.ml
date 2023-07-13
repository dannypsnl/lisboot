(* open Lexing *)
open Sys
module L = Lisboot.Lexer
module P = Lisboot.Parser


let rec parse' f source =
  let lexbuf = Lexing.from_channel source in
  try f L.token lexbuf
  with P.Error ->
    raise (Failure ("Parse error at " ^ pos_string lexbuf.lex_curr_p))

    and pos_string pos =
    let l = string_of_int pos.pos_lnum and c = string_of_int (column pos + 1) in
    "line " ^ l ^ ", column " ^ c
and column pos = pos.pos_cnum - pos.pos_bol - 1

let parse_program source = parse' P.program source


let () = 
  let file_name = Array.get Sys.argv 1 in
  if file_exists file_name then
    let in_chan = open_in file_name in
    (* parsing *)
    let prog = parse_program in_chan in
    let out_chan = open_out "output.zig" in
    Lisboot.Compile.compile prog out_chan
  else
    print_endline ("no file named " ^ file_name)
