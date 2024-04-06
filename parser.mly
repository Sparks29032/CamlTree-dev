%{
open Ast
%}

%token LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK SEMI COMMA
%token ROOT NODE RARROW LARROW BTICK
%token CONNECT CREATE EVAL GIVE CHECK RUN REPLACE
%token DEF RETURN IF ELSE WHILE FOR IN
%token PLUS MINUS TIMES DIV MOD ASSIGN EQ NEQ LT LEQ GT GEQ AND OR NOT
%token <int> INT
%token <bool> BOOL
%token <string> ID
%token EOF

%start program
%start <Ast.program> program

%right ASSIGN
%left OR
%left AND
%left EQ NEQ
%left LT LEQ GT GEQ
%left PLUS MINUS
%left TIMES DIV

%%

program:
	decls EOF { $1}

decls:
	{ ([], []) }
  | vdecl NL decls { (($1 :: fst $3), snd $3) }
	
vdecl_list:
  /*nothing*/ { [] }
  | vdecl SEMI vdecl_list  {  $1 :: $3 }
	
vdecl:
  typ ID { ($1, $2) }
	
typ:
    INT		{ Int }
  | BOOL	{ Bool }