fun alternate (xs: int list) -> int = 0
fun min_max (xs: int list) -> int * int = (0, 0)
fun cumsum (xs: int list) -> int list = [1,2,3]
fun greeting (str: string option) -> string = "a"
fun repeat (int list * int list) -> int list = [1,2,3]
fun addOpt (int option * int option) -> int option = SOME 1
fun addAllOpt = 0
  (* return true if any element in list is true *)
fun any xs  =  
  if null xs then false
  else (hd xs) orelse (any (tl xs))

fun all xs =
    if null xs then true
    else (hd xs) andalso (all (tl xs))
    
fun zip (xs, ys) =
    if null xs orelse null ys then []
    else (hd xs, hd ys) :: zip (tl xs, tl ys)

fun zipRecycle (xs, ys) = []

fun zipOpt (xs, ys) = []

fun lookup (lst, str) = 0
