{
  open Lexing
  open Parser

  let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + 1
    }
}

let digit = ['0'-'9']
let sign = ['-' '+']
let alpha = ['a'-'z' 'A'-'Z']
let id_alpha = alpha | ['-' '+' '*' '/']

let int_constant = sign? digit+
let identifier = id_alpha (id_alpha | digit | '-')*

let whitespace = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"

(* Rules *)
rule token = parse
  | '(' { L_PAREN }
  | ')' { R_PAREN }
  | "#t" { BOOL true }
  | "#f" { BOOL false }
  | "define" { DEFINE }
  | "lambda" { LAMBDA }
  | identifier { IDENTIFIER (Lexing.lexeme lexbuf) }
  | int_constant { INT (int_of_string (Lexing.lexeme lexbuf)) }
  (* etc. *)
  | "//" { single_line_comment lexbuf }
  | whitespace { token lexbuf }
  | newline  { next_line lexbuf; token lexbuf }
  | eof { EOF }
  | _ { raise (Failure ("Character not allowed in source text: '" ^ Lexing.lexeme lexbuf ^ "'")) }
and single_line_comment = parse
  | newline { next_line lexbuf; token lexbuf }
  | eof { EOF }
  | _ { single_line_comment lexbuf }
