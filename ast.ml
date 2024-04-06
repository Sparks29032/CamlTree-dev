type unop = Not

type binop =
  | Add | Sub | Mult | Div | Mod
  | Lt | Leq | Eq | Neq | Gt | Geq  
  | And | Or

type typ = Int | Bool

type expr =
    Literal of int
  | BoolLit of bool
  | Id of string
  | Binop of expr * binop * expr
  | Unop of unop * expr
  | Assign of string * expr
  | Call of string * expr list


type stmt =
  | Expr of expr
  | If of expr * stmt * stmt
  | For of expr * typ list
  | Return of expr

type bind = typ * string

type func_def = {
  rtyp: typ;
  fname: string;
  formals: bind list;
  locals: bind list;
  body: stmt list;
}

type ntyp = Root | Node

type nbind = ntyp * string

type forward_def = {
  rtyp: ntyp list;
  pnode: ntyp;
  cnode: ntyp;
  formals: nbind list;
  locals: bind list;
  body: stmt list;
}

type backward_def = {
  rtyp: typ;
  pnode: ntyp;
  cnode: ntyp;
  formals: nbind list;
  locals: bind list;
  body: stmt list;
}

type program = bind list * func_def list * forward_def list * backward_def list