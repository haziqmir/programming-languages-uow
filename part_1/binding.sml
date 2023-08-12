val a = 10
(* this value is hidden by the REPL as it's not relevant after being shadowed *)
(* a : int
   a -> 10 *)

val b = a * 2
(* b -> 20 *)

val a = 5
(* a -> 5, b -> 20 *)

val c = b
(* a -> 5, c -> b -> 20 *)

val d = a
(* d -> a -> 5, c -> b -> 20 *)

val a = a + 1
(* d -> 5, c -> b -> 20, a -> 6 *)

(* val g = f - 3 *)

val f = a * 2
(* f -> 12, a -> 6 *)

