
(**EXO2**)

(* ---------------------- *)
(* Lists *)
let rec switch = function
  | [] -> []
  | [a] -> [a]
  | a::(b::tl) -> b::(a::(switch tl))
;;

switch [];;
switch [1];;
switch [1 ; 2];;
switch [1 ; 2 ; 3];;
switch [1 ; 2 ; 3 ; 4];;
switch [1 ; 2 ; 3 ; 4 ; 5];;
switch [1 ; 2 ; 3 ; 4 ; 5 ; 6];;

let rec unpair = function
  | [] -> []
  | (a,b)::tl -> (a:: (b:: (unpair tl)))
;;
unpair [];;
unpair [ (3,4) ];;
unpair [ (3,4) ; (10,11) ];;
unpair [ (3,4) ; (10,11) ; (20,30) ];;


let rec remove_succ = function
  | [] -> []
  | [a] -> [a]
  | a::(b::tl) -> 
      if (b = (a+1)) then remove_succ (b::tl)
      else a::( remove_succ (b::tl))
;;
remove_succ [];;
remove_succ [ 10 ];;
remove_succ [ 10 ; 20 ];;
remove_succ [ 10 ; 20 ; 21 ];;
remove_succ [ 10 ; 20 ; 21 ; 22 ; 23 ; 24; 100 ; 101 ; 110 ];;
remove_succ [ 20 ; 21 ; 22 ; 21 ; 22 ; 23 ];;

let rec combine alist blist =
  match (alist, blist) with
    | [],[] -> []
    | [a],[b] -> [(a,b)]
    | a::atl, b::btl -> (a,b)::(combine atl btl)
    | _,_ -> raise (Failure "Diff_size")
;;

combine [ 10 ; 20 ; 30 ] [ 4 ; 5 ; 6 ];;
(* combine [ 10 ; 20 ; 30 ] [ 4 ; 5 ; 6 ; 9 ];; *)

let rec keep alist blist=
  match (alist, blist) with
    | [],[] -> []
    | a::atl, true::btl ->  a::(keep atl btl)
    | a::atl, false::btl -> keep atl btl
    | _,_ -> raise (Failure "Diff_size")
;;
keep [ 1 ; 2 ; 3 ; 4 ; 5 ] [ true ; true ; false ; false ; false ];;
keep [ 1 ; 2 ; 3 ; 4 ; 5 ] [ false ; false ; false ; false ; false ];;
keep [ 1 ; 2 ; 3 ; 4 ; 5 ] [ false ; true ; false ; true ; false ];;


(** rest map2 interleave**)

(*-------------------------*)
(* Variants *)
type bool3 = BTrue | BFalse | Unknown;;

let and3 b1 b2 =
  match (b1,b2) with
    | BFalse,_  | _, BFalse -> BFalse
    | BTrue, x  | x, BTrue -> x
    (*| BTrue,_ -> b2
      | _,BTrue -> b1*)
    | Unknown, Unknown -> Unknown
;;

and3 BTrue Unknown;;
and3 BFalse Unknown;;

let not3 = function
  | BTrue -> BFalse
  | BFalse -> BTrue
  | Unknown -> Unknown
;;

type instruction = Plus of int | Mul of int;;

let rec apply_instructions n = function
  | [] -> n
  | (Plus x) ::tl -> apply_instructions (n+x) tl
  | (Mul x) ::tl -> apply_instructions (n*x) tl
;;


apply_instructions 100 [];;
apply_instructions 100 [ Plus 5 ];;
apply_instructions 100 [ Plus 1 ; Mul 3 ];;
apply_instructions 100 [ Plus 1 ; Mul 3 ; Plus 10;];;

let to_fun = function
  | Plus a -> (fun x -> (a+x))
  | Mul a -> (fun x -> (a*x))
;;

let rec to_funlist = 
  function
    | [] -> []
    | a::tl -> (to_fun a)::(to_funlist tl)
;;

to_funlist [ Plus 4 ];;
to_funlist [ Mul 3 ; Plus 1 ];;
List.map (fun f -> f 100) (to_funlist [ Mul 3 ; Plus 1 ]);;

(**Rest compact, to_string**)

(*--------------------------*)
type people =
    { name: string ;
      age:  int }
;;





