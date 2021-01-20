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


