let l1 = [true,1];;
"Hello";;

(* div_pair (x,y) divides x by y or returns 0 if y is 0 *)
let div_pair (x,y)  =
  if y = 0 then 0 else x / y
;;

(* addp uncurried *)
let addp (x,y) = 
  x + y
;;

(* test addp *)
addp (1,2);;

(* choose return true if the argument (a,b,c) is such that a<b+c*)
let choose (a,b,c) = 
  a < (b + c) 
;;

(* test choose *)
choose (1,2,3);;
choose (0,2,5);;
choose (6,2,3);;

(* head_cmp retun true iff the first element of the list is >0 
 * if empty list, then return false*)
let head_cmp (l : int list) = 
  if l = [] then
    false
  else
    ( (List.hd l) > 0 )
;;

(* test head_cmp *)
let l1 = 1::[1;2;3;4];;
let l2 = [-1;2;-3;4];;
let l3 = [];;
let l4 = [0];;
head_cmp l1;;
head_cmp l2;;
head_cmp l3;;
head_cmp l4;;


(* divp first curried fonction *)
let divp x y = 
  if y = 0 then 0 else x/y
;;

(* return a pair of values *)
let g x y = (x > 0, 2 * y);;

(* test g *)
g 1 2;;
g 0 (-1);;

(* choosec curried return true if the argument (a,b,c) is such that a<b+c*)
let choosec a b c = 
  a < (b + c)
;;

(*test choosec *)
choosec 1 2 3;;
choosec (-2) 5 9;;
choosec 6 2 3;;

(* pmul curried version which takes two arguments and 
 * return a pair sum and product *)
let pmulc x y =
  ( x + y, x * y)
;;

(* test pmulc *)
pmulc 2 3;;

(*-------------------------------------------------------------------*)
(* lambdas anonymous functions*)

let mul2 = ( * ) 2 ;;
let mul3 = ( * ) 3 ;;
let mul_list = [mul2; mul3];;

let lambda_list = [ (fun x -> x * 2) ; (fun x -> x * 3) ];;
let mul2 = (fun x -> x * 2) ;;
let f x y z = x - y * z ;;
let f = (fun x y z -> x - y * z);;
let f (x,y,z) = x - y * z ;;

(*-------------------------------------------------------------------*)
(* polymorphism *)

let mk_pair a b = (a,b);;
let mk_list a b = [ a ; b ];;

let a = mk_pair true
let b = mk_list true
let c = mk_pair (true, 4)
let d = mk_list (true, 4)
let e = mk_pair [ 5 ] 
let f = mk_list [ 5 ] 
let g = mk_list (+) 

;;

List.hd;;
(<);;
fst;;
let fun_if a b c = if a then b else c;;

(*-------------------------------------------------------------------*)
(* recursive functions *)

(* Recursive function ⇒ the rec keyword is mandatory. *)
let rec length l =
  if l = [] then 0
  else 1 + length (List.tl l)
;;

let rec length_bis acu l =
  if l = [] then acu
  else length_bis (acu + 1) (List.tl l)
;;

let n = length_bis 0 [ 1 ; 2 ; 3 ; 4 ; 5 ];;

(* excercise : recursive functions *)
let rec count_ones acc l =
  if l = [] then acc
  else if List.hd l = 1 then 
    count_ones (acc + 1) (List.tl l)
  else count_ones acc (List.tl l)
;;

count_ones 0 [] ;;
count_ones 0 [ 1 ] ;;
count_ones 0 [ 8 ] ;;
count_ones 0 [ 8 ; 9 ];;
count_ones 0 [ 8 ; 1 ; 9 ; 1 ; 9 ];;
count_ones 0 [ 1 ; 1 ; 1 ; 9 ; 1 ];;
count_ones 10 [ 1 ; 1 ; 1 ; 9 ; 1 ];;


let rec sum acc l =
  if l = [] then acc
  else sum (acc + (List.hd l)) (List.tl l)
;;

sum 0 [];;
sum 0 [ 1 ];;
sum 0 [ 8 ];;
sum 0 [ 8 ; 9 ];;
sum 0 [ 8 ; 1 ; 9 ];;
sum 0 [ 8 ; 1 ; 9 ; 1 ; 9 ];;
sum 0 [ 1 ; 1 ; 1 ; 9 ; 1 ];;
sum 10 [ 1 ; 1 ; 1 ; 9 ; 1 ];;


(*-------------------------------------------------------------------*)
(* Exercise : Test tail-recursion (that is, recursion with an accumulator) *)
(* add acc in at top of the list until n*)
let rec mk_list_with_l acc n l =
  if n = 0 then []
  else if acc < n then mk_list_with_l (acc + 1) n ((acc+1) :: l)
  else l
;;

let mk_list x = mk_list_with_l 0 x [];; 
mk_list 0 ;;
mk_list 6 ;;

(* rest mk aculist a faire.....*)
let rec mk_aculist l n=
  if n = 0 then l
  else mk_aculist  (n :: l) (n-1)
;;


mk_aculist [] 0;;
mk_aculist [] 5;;
mk_aculist [99] 5;;

let l1 = mk_list 100000;;
let l1 = mk_list 1000000;;
let l2 = mk_aculist [] 1000000;;
count_ones 0 l2;;


(*-------------------------------------------------------------------*)
(* Higher-order fonctions*)
let fun_list = [ count_ones ; sum ] ;;
let fun_pair = ( count_ones, sum );;

let fsum f = f 0 + f 1 + f 2 + f 3;;
let flist f = [ f 0 ; f 1 ; f 2 ; f 3 ];;
flist string_of_int;;
flist (fun x -> x + 1);;
flist (fun x -> x);;

let rec fsumlist_acc acc f l = 
  if l = [] then acc
  else fsumlist_acc (acc + (f List.hd l)) f (List.tl l)
;;

let rec map f l = 
  if l=[] then []
  else (f(List.hd l)) ::(map f (List.tl l))
;;

map (fun x -> x + 1) [];;
map (fun x -> x + 1) [ 5 ];;
map (fun x -> x + 1) [ 5 ; 10 ; 15 ];;

let rec find f l = 
  if l=[] then raise Not_found
  else if f (List.hd l) then true
  else false || find f (List.tl l)
;;

find (fun x -> x > 10) [ 5 ; 12 ; 7 ; 8 ];;
find (fun x -> true) [];;
find (fun x -> x > 10) [ 5 ; 6 ; 7 ; 8 ];;
find (fun x -> true) [ 5 ; 10 ; 15 ];;

