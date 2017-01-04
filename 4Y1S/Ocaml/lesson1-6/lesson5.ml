
(* ------------------------ *)
(* Practicing on lists*)
let rec nth alist n = 
  match (alist,n) with
    | ([],_) -> failwith "List too small"
    | (a::_, 0) -> a
    | (_::tl, _) -> nth tl (n-1)
;;

let rec rev_acc l l_inv = 
  match l with
    | [] -> l_inv
    | a::tl -> rev_acc tl (a::l_inv)
;;

let rev l = rev_acc l [];;

rev [ 1 ; 2 ; 3 ];;
(* -------- *)

let rec append l1 l2 = 
  match l1 with
    | [] -> l2
    | a::tl -> a:: (append tl l2)
;;

append [ 1 ; 2 ] [ 3 ; 4 ];;


let rec rev_append l1 l2 = 
  match l1 with
    | [] -> l2
    | a::tl -> append tl (a::l2)
;;

rev_append [ 1 ; 2 ] [ 3 ; 4 ] ;;


(* -------- *)
(* Higher-order functions on lists *)
let rec map f alist = 
  match alist with
    | [] -> []
    | a::tl -> (f a) :: (map f tl)
;;

let rec rev_map_acc acc f alist = 
  match alist with
    | [] -> acc
    | a::tl -> rev_map_acc ((f a)::acc)  f tl
;;

let rev_map f alist =  rev_map_acc [] f alist;;

let rec iter f alist =
  match alist with 
    | [] -> ()
    | a::tl -> f a; (iter f tl)
;;

let rec print_list sep conv alist = 
  match alist with 
    | [] -> ()
    | a::tl -> Printf.printf "%s%!" ((conv a)^sep); 
        print_list sep conv tl
;;
print_list ", " string_of_int [ 4 ; 8 ; 99 ];;
print_list " ++ " (fun x -> x) [ "aa" ; "bb" ; "cc" ];;

let rec fold op acu  = function
  | [] -> acu
  | a::tl -> fold op (op acu a) tl
;;
fold (+) 0 [ 1 ; 2 ; 3 ; 4 ];;
fold ( * ) 1 [ 1 ; 2 ; 3 ; 4 ];;
fold (fun a b -> a ^ " " ^ string_of_int b) "" [ 1 ; 2 ; 3 ; 4];;
fold (fun a b -> if a < b then b else a) 0 [ 10 ; 40 ; 20 ; 30 ];;
fold (fun a b -> b :: a) [] [ 4 ; 3 ; 2 ; 1 ];;


let rec exists pred alist = match alist with
  | [] -> false
  | a::tl -> (pred a) || (exists pred tl)
;;
exists (fun x -> x < 10) [ 20 ; 5 ; 30 ];;
exists (fun x -> x < 10) [ 20 ; 40 ; 30 ];;
exists (fun x -> x < 10) [];;

let exists pred alist = fold (fun x y -> x || (pred y) ) false alist;;
exists (fun x -> x < 10) [ 20 ; 5 ; 30 ];;
exists (fun x -> x < 10) [ 20 ; 40 ; 30 ];;
exists (fun x -> x < 10) [];;

let (++) f g x = f (g x);;
((fun x -> x - 10) ++ abs) (-20);;
(abs ++ (fun x -> x - 10)) (-20);;


let forall pred alist = 
  not (exists (fun x-> not (pred x)) alist)
;;
forall (fun x -> x < 10) [ 20 ; 40 ; 30 ];;
forall (fun x -> x > 10) [ 20 ; 40 ; 30 ];;
forall (fun x -> x > 10) [ 20 ; 5 ; 30 ];;

(* ------------------------- *)
(* assiciation list *)
let assoc1 = [ ("Lucy", true) ; ("Mike", false) ; ("Hilary", false) ; ("Donald", true) ];;
let rec assoc key assoc_list = 
  match assoc_list with
    | [] -> raise Not_found
    | (a,b)::tl -> 
        match a = key with
          | true -> b
          | false -> assoc key tl
;;
assoc "Donald" assoc1;;
assoc "Mike" assoc1;;
(* assoc "donald" assoc1;;*)


let rec remove_assoc acu_head_inv key assoc_list = 
  match assoc_list with
    | [] -> raise Not_found
    | (a,b)::tl -> 
        match a = key with
          | true -> append (rev(acu_head_inv)) tl
          | false -> remove_assoc ((a,b)::acu_head_inv) key tl
;;

remove_assoc [] "Donald" assoc1;;

(* -------------------------- *)
(* Trees *)
type 'a tree = Leaf of 'a | Node of 'a tree * 'a tree;;
let max a b = if b > a then b else a;;

let rec depth = function
  | Leaf _ -> 0
  | Node (tree_l,tree_r) -> (max (depth tree_l) (depth tree_r)) + 1
;;
depth (Leaf 100);;
depth (Node (Leaf 100, Leaf 200));;

let rec build n x =
  if n <= 0 then Leaf x
  else Node ((build (n-1) x), (build (n-1) x))
;;
let tree1 = build 4 3;;
depth tree1;;

let print_tree tos tree =
  let rec loop margin = function
    | Leaf x -> Printf.printf "___ %s\n" (tos x)
    | Node (a,b) ->
        Printf.printf "____" ;
        loop (margin ^ "|   ") a ;
        Printf.printf "%s|\n%s|" margin margin ;
        loop (margin ^ "    ") b
  in
    loop "   " tree
;;


let rec build_fold n init f =
  let rec fn nx initx fx= match nx with 
    (* appliquer fx a initx nx fois*)
    | 0 -> initx
    | nx -> fn (nx-1) (fx initx) fx
  in
    match n with 
      | 0 -> Leaf init
      | _ -> Node ( build_fold (n-1) init f , 
                    build_fold (n-1)
                      (fn (int_of_float(2.** float_of_int(n-1))) init f)
                      f)
;;

let rec build_fold n init f =
  let rec loop nx initx= 
    match nx with
      | 0 -> (Leaf initx, initx)
      | nx -> let (a1, init_l_end) = loop (nx-1) initx in
          let (a2, init_r_end) = loop (nx-1) (f init_l_end) in
            (Node(a1, a2), init_r_end)
  in
  let (t,init_end) = loop n init in
    t
;;

let tree1 = build_fold 3 10 (fun x -> x+2);;
print_tree string_of_int tree1;;
Printf.printf "%!" ;;
let tree2 = build_fold 2 "o" ( fun x -> "(" ^ x ^ ")" );;
print_tree (fun x->x) tree2;;
Printf.printf "%!" ;;

let rec tmap f = function
  | Leaf a -> Leaf (f a)
  | Node(n1, n2) -> Node ((tmap f n1), (tmap f n2))
;;
tmap (fun x->x+1) tree1;;

let rec tfind pred atree =
  let rec bfind pred = function
    | Leaf a -> (pred a, a)
    | Node(n1, n2) ->
        match bfind pred n1 with
          | (true, a) -> (true, a)
          | (false,_) -> bfind pred n2
  in
    match bfind pred atree with
      | (true, a) -> Some a
      | (false,_) -> None
;;
tfind (fun x -> x > 15) tree1;;
tfind (fun x -> x > 25) tree1;;

let rec contains x = function
  | Leaf a -> x = a
  | Node(n1, n2) -> (contains x n1) || (contains x n2)
;;
contains 18 tree1;;
contains 25 tree1;;

let rec replace pred sub tree = 
  match pred tree with
    | true -> sub
    | false -> 
        match tree with
          | Leaf a -> Leaf a
          | Node(n1, n2) -> Node ( replace pred sub n1, 
                                   replace pred sub n2)
;;
replace (fun t -> contains 14 t && depth t = 1) (Leaf 0) tree1
;;
