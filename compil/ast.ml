type type_expr =
  | TInt
  | TPair of type_expr * type_expr
  | TObj
  | TClass
[@@deriving show]

type value =
  | V_Int of int
  | V_String of string
  | V_Var of int
  | V_Cons of string * value list
  | V_Sum of value * value
  | V_Prod of value * value
  | V_Diff of value * value
  | V_Div of value * value
[@@deriving show]

type cond =
  | C_Bool of bool
  | C_Le of value * value
  | C_Eq of value * value
  | C_Ne of value * value
  | C_Lt of value * value
  | C_Ge of value * value
  | C_Gt of value * value
  | C_And of cond * cond
  | C_Or of cond * cond
  | C_Not of cond
[@@deriving show]

type stmt =
  | S_print of value
  | S_if of cond * stmt list * stmt list
  | S_while of cond * stmt list
  | S_affect of int * value
[@@deriving show]

type definition =
  | D_Class of string * (type_expr * string) list
  | D_Main of (type_expr * string) list * stmt list