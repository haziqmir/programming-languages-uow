val x = 7

fun pow(x: int, y: int) =
    if y = 0 then 1
    else x * pow(x, y-1)
(*
this above is not a curried function so it cannot be called without parentheses
to curry it, just means the parentheses in the definition and wherever called
*)

fun cube(x: int) =
    pow(x, 3)

val sixtyfour = cube(4)

val fortyfour = pow(2,2+2) + pow(4,2) + cube(2) + 2