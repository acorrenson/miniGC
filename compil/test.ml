open Opal
open MiniGC.Parser
open MiniGC.Ast

let _ =
  "class Main { private int x; main() { } }"
  |> LazyStream.of_string
  |> (parse parse_definition)
  |> function
  | None -> failwith "err"
  | Some r -> print_endline (show_definition r)