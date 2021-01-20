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