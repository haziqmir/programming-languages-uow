(* this is a comment *)
val x = 24; (* int *)
val y = 4.23; (* real *)
val str = "hello"; (* string *)
val z = ~20; (* int *)
val cs = 1::[] (* int list *)
val ds = 2::cs (* int list *)

val abs_of_z = if z < 0 then 0-z else z; (* int *)
val i = z > 0; (* bool *)