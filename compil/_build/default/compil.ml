(* open Parser *)
(* open Opal *)

(* open Ast

   type asm =
   | ASM_push_int of int
   | ASM_push_vec
   | ASM_prod
   | ASM_sum
   | ASM_vsum
   | ASM_vdot
   (* | VMag *)
   (* | VScale *)

   let rec compile_int_expr (e : int_expr) =
   match e with
   | Int i -> [ASM_push_int i]
   | Sum (el, er) ->
    (compile_int_expr el) @ (compile_int_expr er) @ [ASM_sum]
   | Prod (el, er) ->
    (compile_int_expr el) @ (compile_int_expr er) @ [ASM_prod]
   | VDot (vel, ver) ->
    (compile_vect_expr vel) @ (compile_vect_expr ver) @ [ASM_vdot]

   and compile_vect_expr (ve : vect_expr) =
   match ve with
   | Vec (el, er) ->
    (compile_int_expr el) @ (compile_int_expr er) @ [ASM_push_vec]
   | VSum (vel, ver) ->
    (compile_vect_expr vel) @ (compile_vect_expr ver) @ [ASM_vsum]

   let rec generate_bin (out : out_channel) (asml : asm list) =
   match asml with
   | [] -> ()
   | (ASM_push_int i)::l ->
    Printf.fprintf out "Push_int %d\n" i;
    generate_bin out l
   | ASM_push_vec::l ->
    Printf.fprintf out "Push_vec\n";
    generate_bin out l
   | ASM_prod::l ->
    Printf.fprintf out "Push_prod\n";
    generate_bin out l
   | ASM_sum::l ->
    Printf.fprintf out "Push_sum\n";
    generate_bin out l
   | ASM_vsum::l ->
    Printf.fprintf out "Push_vsum\n";
    generate_bin out l
   | ASM_vdot::l ->
    Printf.fprintf out "Push_vdot\n";
    generate_bin out l


   let _ =
   VSum (Vec (Int 1, Int 2), Vec(Int 3, Int 4))
   |> compile_vect_expr
   |> generate_bin (open_out "code.minigc") *)

(* let main () =
   LazyStream.of_string "pair<pair<int,int>,int>" |> parse_type_expr *)
let main =
  Ast.TInt |> Ast.show_type_expr |> print_endline