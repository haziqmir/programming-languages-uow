(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end


(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

fun only_capitals strs =
  List.filter (fn x => Char.isUpper(String.sub(x,0))) strs

fun longest_string1 strs = 
  foldl (fn (x,y) => if String.size x > String.size y then x else y) "" strs 

fun longest_string2 strs =
  foldl (fn (x, y) => if String.size x < String.size y then y else x) "" strs

fun longest_string_helper flt strs =
  foldl flt "" strs

val longest_string3 = longest_string_helper (fn (x, y) => if String.size x >
String.size y then x else y)

val longest_string4 = longest_string_helper (fn (x, y) => if String.size x <
String.size y then y else x)

val longest_capitalized = longest_string3 o only_capitals

val rev_string = String.implode o List.rev o String.explode

(* functions over lists *)

fun first_answer f = fn xs => case xs of
                                    [] => raise NoAnswer
                                  | x::xs' => case f x of
                                                  SOME v => v
                                                | NONE => first_answer f xs'

fun all_answers f lst =
  let fun aux (lst', acc) =
    case lst' of
       [] => SOME acc
     | x::xs' => case (f x) of
                    SOME x => aux (xs', acc@x)
                  | NONE => NONE
  in
    aux(lst, [])
  end


val count_wildcards = g (fn _ => 1) (fn _ => 0)

val count_wild_and_variable_lengths = g (fn _ => 1) String.size

fun count_some_var (str: string, ptn: pattern) =
  g (fn _ => 0) (fn x => if x = str then 1 else 0) ptn

(* Write a function check_pat that takes a pattern and returns true if and only if all the variables
appearing in the pattern are distinct from each other *)

fun check_pat ptn = 
  let 
    fun build_list p = 
      case p of
           Wildcard => []
         | Variable str => [str]
         | UnitP => []
         | ConstP _ => []
         | TupleP plist => List.foldl (fn (p, vs) => build_list p @ vs) [] plist
         | ConstructorP(_, p') => build_list p'
    fun is_repeating_str [] = false
      | is_repeating_str (x::xs) = List.exists (fn y => x = y) xs
  in
    not(is_repeating_str(build_list ptn))
  end 

fun match (v: valu, p: pattern) =
  case (v, p) of
       (_, Wildcard)         => SOME []
     | (_, Variable s)       => SOME [(s, v)]
     | (Unit, UnitP)         => SOME []
     | (Const x, ConstP y)   => if x = y then SOME [] else NONE
(*
* all_answers ('a -> 'b option) -> 'a list -> 'b list option
*
* match: valu * pattern -> (string * valu) list option
*
* 'a : (valu * pattern)
* 'b : (string * valu) list
*
* (ListPair.zip([Const(12), Const(11)], [Variable("def"), Variable("abc")]));
* (valu * pattern) list
*
* 'a list which is my list of valu * pattern tuples
* 'b list option is (string * value) list list option
*
* *)
     | (Tuple vs, TupleP ps) =>
         if List.length vs = List.length ps
         then all_answers (match) (ListPair.zip(vs, ps))
         else NONE
     | (Constructor(s1, v'), ConstructorP(s2, p')) => 
         if s1 = s2
         then match(v', p')
         else NONE
     | (_, _)               => NONE


fun first_match v ps = (* -> (string * valu) list option *)
  SOME (first_answer (match) (List.map (fn x => (v, x)) ps))
  handle NoAnswer => NONE

