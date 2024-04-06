{
  open Parser
}

let digit = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z']
let whitespace = [' ' '\t']

rule token = parse
  | whitespace  	{ token lexbuf }
  | "/*"        	{ comment lexbuf }
  
  (**)
  | '('         { LPAREN }
  | ')'         { RPAREN }
  | '['         { LBRACK }
  | ']'         { RBRACK }
  | '{'         { LBRACE }
  | '}'         { RBRACE }
  | ';'         { SEMI }
  | ('\r\n' | '\n') as lem	{ NL }
  | ','        	{ COMMA }
  | '='         { ASSIGN }
  
  (*trml objects and functions*)
  | "root"      { ROOT }
  | "node"		{ NODE }
  | "->"		{ RARROW }
  | "<-"		{ LARROW }
  | "\'"		{ BTICK }
  
  (*trs forward/backward connectors*)
  | "connect"   { CONNECT }
  | "create"    { CREATE }
  | "eval"      { EVAL }
  | "give"      { GIVE }
  
  (*camltree running functions*)
  | "check"    	{ CHECK }
  | "run"       { RUN }
  | "replace"   { REPLACE }
  
  (*functions*)
  | "def"       { DEF }
  | "return"    { RETURN }
  
  (*conditionals and loops*)
  | "if"        { IF }
  | "else"      { ELSE }
  | "while"     { WHILE }
  | "for"       { FOR }
  | "in"        { IN }
  
  (*boolean operators*)
  | "bool"     	{ BOOL }
  | "True"     	{ BLIT(true) }
  | "False"     { BLIT(false) }
  | "=="       	{ EQ }
  | "!="       	{ NEQ }
  | '<'        	{ LT }
  | "<="       	{ LEQ }
  | '>'        	{ GT }
  | ">="        { GEQ }
  | "and"       { AND }
  | "or"        { OR }
  | "not"       { NOT }
  
  (*operators*)
  | "int"       { INT }
  | '+'         { PLUS }
  | '-'         { MINUS }
  | '*'         { TIMES }
  | '/'         { DIV }
  | '%'         { MOD }
  
  (**)
  | digit+ as lem	{ LITERAL(int_of_string lem) }
  | letter (digit | letter | '_') as lem	{ ID(lem) }
  | eof         { EOF }
  | _ as char   { raise (Failure("illegal charager " ^ Char.escaped.char)) }

and comment = parse
    "*/"       { token lexbuf }
  | _          { comment lexbuf }
