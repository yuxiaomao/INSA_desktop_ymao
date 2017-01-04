
(** ex 1 **)
let e1q1 n s =
  let rec e1q1acc n s acc =
    if (n=0) then acc
    else e1q1acc (n-1) s (s^acc) in
    e1q1acc n s ""
;;

let test_e1q1 =
  Printf.printf "%s\n" (e1q1 0 "ab");
  Printf.printf "%s\n" (e1q1 1 "ab");
  Printf.printf "%s\n" (e1q1 3 "ab");
  Printf.printf "%!"
;;

(*--------------------------*)
let e1q2 n sep =
  let rec e1q2acc n sep acc =
    if (n=0) then acc
    else let der = n mod 10 in
        e1q2acc (n/10) sep (acc^(string_of_int der)^sep)
  in
    e1q2acc n sep ""
;;

e1q2 0 ":";;
e1q2 7 ":";;
e1q2 72 ":";;
e1q2 987 ":";;
(*--------------------------*)
let e1q3 n sep =
  let rec e1q3acc n sep acc =
    if (n=0) then acc
    else let der = n mod 10 in
        e1q3acc (n/10) sep ((string_of_int der)^sep^acc)
  in
    e1q3acc n sep ""
;;

e1q3 987 "#";;
(*--------------------------*)
let e1q4 n =
  let rec e1q4acc n acc =
    if (n=0) then acc
    else  let inter = n/10 in
        if (inter>0) then e1q4acc inter (acc+1)
        else (acc+1)
  in
    e1q4acc n 0
;;

e1q4 0;;
e1q4 1;;
e1q4 10;;
e1q4 99;;
e1q4 999;;
(*--------------------------*)

let rec e1q5 n b = 
  match (n,b) with
    | (0, _) -> true
    | (_,true) -> (((n mod 10) mod 2) = 0) && e1q5 (n/10) b
    | (_,false) -> (((n mod 10) mod 2) = 1) && e1q5 (n/10) b
;;
e1q5 0 true;;
e1q5 0 false;;
e1q5 17359 false;;
e1q5 17369 false;;
e1q5 288062 true;;
e1q5 298462 true;;

(*--------------------------*)

let rec e1q6 n m =
  if (n=0) then true
  else (n mod 10 < m mod 10) && e1q6 (n/10) (m/10)
;;
e1q6 0 0;;
e1q6 1234 2345;;
e1q6 1234 999;;
e1q6 999 1648;;
e1q6 333 1444;;

(*--------------------------*)
(* Curried functions *)
let curry3 f a b c = f (a,b,c);;
let ccat (a,b,c) = a ^ b ^ c;;
let fccat = curry3 ccat;;
let _ = fccat "a" "b" "c";;

let uncurry3 f (a, b, c) = f a b c;;

(** pas besoin de penser trop.....**)
let apply (f1,f2,f3) (a1,a2,a3) =
  (f1 a1, f2 a2, f3 a3)
;;

let sort2 f g x =
  if ((f x) < (g x)) then (f,g)
  else (g,f)
;;

let comp3 f g h x =
  (f (g (h x)))
;;


(* --------------------------------- *)
(* pattern matching *)
let ext_and a b c =
  match (c,a,b) with (*c first!*)
    | (true,true,_) -> b
    | (true,false,_) -> false
    | (false,true,true) -> false
    | (false,true,false) -> true
    | (false,false,_) -> true
;;

(**Solution prof**)
let ext_and a b c = match (a,b,c) with
  | false, _, true
  | _, false, true -> false

  | false, _, false
  | _, false, false -> true

  | true, true, true -> true
  | true, true, false -> false 
;;
(**END**)

ext_and false true true;;
ext_and false true false;;
ext_and true true false;;
ext_and true true true;;

let encode_char = function
  |'a' -> 'y'
  |'e' -> 'a'
  |'i' -> 'e'
  |'o' -> 'i'
  |'u' -> 'o'
  |'y' -> 'u'
  |'A' -> 'E'
  |'E' -> 'I'
  |'I' -> 'O'
  |'O' -> 'U'
  |'U' -> 'Y'
  |'Y' -> 'A'
  | x -> x
;;

let encode s =
  String.map encode_char s
;;
encode "I am a superhero.";;
encode "Les bons etudiants";;

