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
    decls EOF { $1 }

decls:
    { ([], [], [], [], [], []) }
  | ndecl NL decls { 
    let (a,b,c,d,e,f) = $3 in 
    (($1::a),b,c,d,e,f) 
  } (*Node declaration*)
  | ldecl NL decls { 
    let (a,b,c,d,e,f) = $3 in 
    (a,($1::b),c,d,e,f) 
  } (*Links to nodes declarations*)
  | vdecl NL decls {
    let (a,b,c,d,e,f) = $3 in 
    (a,b,($1::c),d,e,f) 
  } (*Variable Declaration*)
  | fdecl NL decls { 
    let (a,b,c,d,e,f) = $3 in 
    (a,b,c,($1::d),e,f) 
  } (*Function declaration*)
  | fwddecl NL decls {
    let (a,b,c,d,e,f) = $3 in 
    (a,b,c,d,($1::e),f) 
  } (*Forward declaration*) 
  | bwddecl NL decls { 
    let (a,b,c,d,e,f) = $3 in 
    (a,b,c,d,e,($1::f)) 
  } (*Backward declaration*)

vdecl_list:
    { [] }
  | vdecl NL vdecl_list  { $1 :: $3 }

vdecl:
  typ ID { ($1, $2) }

ndecl_list:
    { [] }
  | ndecl NL vdecl_list  { $1 :: $3 }

typ:
    INT		{ Int }
  | BOOL	{ Bool }

ndecl:
  ntyp ID { ($1, $2) }

ntyp:
    ROOT    { Root }
  | NODE    { Node }

fdecl:
    vdecl LPAREN formals_opt RPAREN vdecl_list stmt_list
    {
      {
        rtyp=fst $1;
        fname=snd $1;
        formals=$3;
        locals=$5;
        body=$6
      }
    }