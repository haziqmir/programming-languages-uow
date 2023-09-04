(* provided function *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2


(* string * string list -> string list option *)
fun all_except_option (str, []) = NONE
  | all_except_option (str, lst_hd::lst_tl) =
    case same_string(str, lst_hd) of 
         true => SOME lst_tl
       | false => case all_except_option(str, lst_tl) of
                       NONE => NONE 
                     | SOME lst_tl' => SOME(lst_hd ::lst_tl')


(* string list list * string -> string list *)
fun get_substitutions1([], s) = []
  | get_substitutions1(x::xs, s) =
    case all_except_option(s, x) of
         NONE => get_substitutions1(xs, s)
       | SOME y => y @ get_substitutions1(xs, s) 


(* string list list * string -> string list *)
fun get_substitutions2(lst, str) = 
  let
    fun aux(_, [], acc) = acc
      | aux(str, x::xs, acc) =
        case all_except_option(str, x) of
             NONE => aux(str, xs, acc)
           | SOME y => aux(str, xs, acc @ y)
  in
    aux(str, lst, [])
  end



(* EXPECTED:
  string list list * {first: string, middle: string, last: string} ->
  {first: string, middle: string, last: string} list
  RECEIVED:
  string list list * {first:string, last:'a, middle:'b}
  -> {first:string, last:'a, middle:'b} list *)
fun similar_names(subs, {first:string,middle:string,last:string}) =
    let
      (* store name for constant reference *)
      val name = {first = first, middle = middle, last = last}
      fun substitute([]) = []
        | substitute(x::xs) =
          {first=x, middle=middle, last=last} :: substitute(xs)
    in
      (* prepend name here and get list of subs to make *)
      name :: substitute(get_substitutions2(subs, first))
    end


(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* Most of these functions are polymorphic *)

fun card_color(card) = 
  case card of
       (Spades, _) => Black
     | (Clubs, _) => Black
     | (_, _) => Red

fun card_value(card) =
  case card of
       (_, Num i) => i
     | (_, Ace) => 11
     | (_, _) => 10

fun remove_card([], c, e) = raise e
  | remove_card(x::xs, c, e) =
        case x=c of
             true =>  xs
           | false => remove_card(xs, c, e)

fun all_same_color([]) = true
  | all_same_color(c::cs) = 
  let
    val comparable_color = card_color(c)
    fun compare [] = true
      | compare (x::xs) = case card_color(x) = comparable_color of
                               false => false
                             | true => compare(xs)
  in
    compare(cs)
  end

fun sum_cards(cardss) =
  let
    fun helper([], acc) = acc
      | helper(c::cs, acc) = helper(cs, acc+card_value(c))
  in 
    helper(cardss, 0)
  end

fun score(cards, goal) =
  let
    val sum = sum_cards(cards)
    (* If sum is greater than goal, the preliminary score is three times (sum−goal),
    else the preliminary score is (goal − sum). *)
    val preliminary_score = if sum>goal then 3*(sum-goal) else (goal-sum)
  in
    (* The score is the preliminary score unless all the held_cards are the same color
    in which case the score is the preliminary score divided by 2 *)
    case all_same_color(cards) of
         false => preliminary_score
       | true => preliminary_score div 2
  end

(* card list * move list * int -> int *)
fun officiate (cards, moves, goal) =
  let
    fun play (deck, moves, hand) =
        case (deck, moves, hand) of 
           (_, [], _) => score(hand, goal)
         | ([], _, _) => score(hand, goal)
         | (deck, moves, hand) =>
              if (sum_cards(hand) > goal) then score(hand, goal)
              else
                case moves of
                     (Discard c)::mvs => play(deck, moves, remove_card(hand, c, IllegalMove))
                    | Draw::mvs => case deck of
                               [] => score(hand, goal)
                             | (d::_) => play(remove_card(deck, d, IllegalMove),
                             mvs, d::hand)
  in
    play (cards, moves, [])
  end
