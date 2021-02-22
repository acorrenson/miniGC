open Opal
open Ast

let (let*) = (>>=)

let rec parse_type_expr inp =
  choice [parse_type_int; parse_type_pair] inp

and parse_type_int =
  token "int" >> return TInt

and parse_type_pair inp =
  let inner =
    let* _ = token "pair<" in
    let* t1 = parse_type_expr in
    let* _ = exactly ',' in
    let* t2 = parse_type_expr in
    let* _ = exactly '>' in
    return (TPair (t1, t2))
  in
  inner inp

let ident = (many1 alpha_num => implode) << spaces

let number = many1 digit => implode % int_of_string

let rec parse_value inp =
  choice [
    parse_int;
    parse_string;
    parse_var;
    parse_cons;
  ] inp

and parse_int inp =
  (number => fun x -> V_Int x) inp

and parse_string inp =
  (exactly '"' >>  (ident => (fun x -> V_String x)) << exactly '"') inp

and parse_var inp =
  (number => (fun x -> V_Var x)) inp

and parse_cons inp =
  let inner =
    let* _ = token "new" << exactly ' ' << spaces in
    let* cons = ident << spaces in
    let* _ = exactly '(' << spaces in
    let* l = sep_by parse_value (exactly ',') in
    let* _ = exactly ')' << spaces in
    return (V_Cons (cons, l))
  in
  inner inp

and parse_sum inp =
  let inner =
    let* a = parse_value << spaces in
    let* _ = exactly '+' << spaces in
    let* b = parse_value << spaces in
    return (V_Sum (a, b))
  in
  inner inp

and parse_prod inp =
  let inner =
    let* a = parse_value << spaces in
    let* _ = exactly '*' << spaces in
    let* b = parse_value << spaces in
    return (V_Prod (a, b))
  in
  inner inp

and parse_div inp =
  let inner =
    let* a = parse_value << spaces in
    let* _ = exactly '/' << spaces in
    let* b = parse_value << spaces in
    return (V_Div (a, b))
  in
  inner inp

and parse_diff inp =
  let inner =
    let* a = parse_value << spaces in
    let* _ = exactly '-' << spaces in
    let* b = parse_value << spaces in
    return (V_Diff (a, b))
  in
  inner inp

let parse_attribute =
  let* _ = token "private" << spaces in
  let* ty = parse_type_expr << spaces in
  let* var = ident << spaces in
  return (ty, var)

let rec parse_cond inp =
  choice [parse_bool;
          parse_le;
          parse_lt;
          parse_ge;
          parse_eq;
          parse_ne;
          parse_gt;
          parse_and;
          parse_or;
          parse_not;
          parse_or;
         ] inp

and parse_bool inp =
  choice [
    token "true" => (fun _ -> C_Bool (true)) << spaces;
    token "false" => (fun _ -> C_Bool (true)) << spaces;
  ] inp

and parse_le inp =
  let inner =
    let* a = parse_value << spaces in
    let* _ = token "<=" << spaces in
    let* b = parse_value << spaces in
    return (C_Le (a, b))
  in
  inner inp

and parse_lt inp =
  let inner =
    let* a = parse_value << spaces in
    let* _ = exactly '<' << spaces in
    let* b = parse_value << spaces in
    return (C_Lt (a, b))
  in
  inner inp

and parse_eq inp =
  let inner =
    let* a = parse_value << spaces in
    let* _ = token "==" << spaces in
    let* b = parse_value << spaces in
    return (C_Eq (a, b))
  in
  inner inp

and parse_ne inp =
  let inner =
    let* a = parse_value << spaces in
    let* _ = token "!=" << spaces in
    let* b = parse_value << spaces in
    return (C_Ne (a, b))
  in
  inner inp

and parse_gt inp =
  let inner =
    let* a = parse_value << spaces in
    let* _ = exactly '>' << spaces in
    let* b = parse_value << spaces in
    return (C_Gt (a, b))
  in
  inner inp

and parse_ge inp =
  let inner =
    let* a = parse_value << spaces in
    let* _ = token "<=" << spaces in
    let* b = parse_value << spaces in
    return (C_Gt (a, b))
  in
  inner inp

and parse_and inp =
  let inner =
    let* a = parse_cond << spaces in
    let* _ = token "&&" << spaces in
    let* b = parse_cond << spaces in
    return (C_And (a, b))
  in
  inner inp

and parse_or inp =
  let inner =
    let* a = parse_cond << spaces in
    let* _ = token "||" << spaces in
    let* b = parse_cond << spaces in
    return (C_And (a, b))
  in
  inner inp

and parse_not inp =
  let inner =
    let* a = parse_cond << spaces in
    return (C_Not a)
  in
  inner inp


let rec parse_stmt inp =
  choice [parse_if; parse_while; parse_affect] inp

and parse_if inp =
  let parse_else =
    let* _ = token "else" << spaces in
    let* _ = exactly '{' << spaces in
    let* body = many (parse_stmt << spaces) in
    let* _ = exactly '}' << spaces in
    return body
  in
  let inner =
    let* _ = token "if" << spaces in
    let* _ = exactly '(' << spaces in
    let* cond = parse_cond << spaces in
    let* _ = exactly '{' << spaces in
    let* ok = many (parse_stmt << spaces) in
    let* _ = exactly '}' << spaces in
    let* ko = parse_else in
    return (S_if (cond, ok, ko))
  in
  inner inp

and parse_while inp =
  let inner =
    let* _ = token "while" << spaces in
    let* _ = exactly '(' << spaces in
    let* cond = parse_cond << spaces in
    let* _ = exactly '{' << spaces in
    let* ok = many (parse_stmt << spaces) in
    let* _ = exactly '}' << spaces in
    return (S_while (cond, ok))
  in
  inner inp

and parse_affect inp =
  let inner =
    let* x = ident << spaces in
    let* _ = exactly '=' << spaces in
    let* v = parse_value << spaces in
    let* _ = exactly ';' << spaces in
    return (S_affect (x, v))
  in
  inner inp



let rec parse_definition inp =
  choice [parse_class; parse_main] inp

and parse_class inp =
  let inner =
    let* _ = token "class" << spaces in
    let* name = ident in
    let* _ = exactly '{' << spaces in
    let* attributes = sep_by parse_attribute (exactly ';') in
    let* _ = exactly '}' << spaces in
    return (D_Class (name, attributes))
  in
  inner inp

and parse_main inp =
  let inner =
    let* _ = token "class" << spaces in
    let* _ = token "Main" << spaces in
    let* _ = exactly '{' << spaces in
    let* attributes = sep_by parse_attribute (exactly ';' << spaces) in
    let* _ = token "main" << spaces in
    let* _ = exactly '(' << spaces in
    let* _ = exactly ')' << spaces in
    let* _ = exactly '{' << spaces in
    let* body = many parse_stmt in
    let* _ = exactly '}' << spaces in
    let* _ = exactly '}' << spaces in
    return (D_Main (attributes, body))
  in
  inner inp

(**
    class MaClass {
      private int x1;
      private int x2;
      private int x3;
    }

    class Main {
      private MaClasse x1;

      void main() {
        x1 = new MaClass(1, 2, 3);
        print(x1);
      }
    }
*)