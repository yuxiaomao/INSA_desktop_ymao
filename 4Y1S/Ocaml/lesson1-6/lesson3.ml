(*----------------------------------------*)
(* Basic pattern matching *)

let f x = 
  match x with
    | 0 -> "zero"
    | 1 -> "one"
    | 2 -> "two"
    | _ -> "another number"


;;

f 0;;
f 1;;
f 2;;
f 3;;

let f tup = 
  match tup with
    | (0, true) -> 1
    | (0, false) -> -1
    | (_, false) -> 2
    | (_, true) -> 3
;;

let f = function
  | (0, true) -> 1
  | (0, false) -> -1
  | (_, false) -> 2
  | (_, true) -> 3
;;

let confused (a,b) = function
  | (0, true) -> 1
  | _ -> 10
;;

confused (1,5) (0,false);;

let foo x y = match (x,y) with
  | (0,0) -> x
  | _ -> y
;;

let bar x y = function
  | (0,0) -> x
  | _ -> y
;;

let calc = function
  | (x, y, "add") -> x + y
  | (x, y, "sub") -> x - y
  | (x, y, "mul") -> x * y
  | (x, 0, "div") -> failwith "Division by zero."
  | (x, y, "div") -> x / y
  | _ -> failwith "Unknown operator."
;;

calc (110, 220, "add");;

let calcc x y l= 
  match (x, y, l) with
    | (x, y, "add") -> x + y
    | (x, y, "sub") -> x - y
    | (x, y, "mul") -> x * y
    | (x, 0, "div") -> failwith "Division by zero."
    | (x, y, "div") -> x / y
    | _ -> failwith "Unknown operator."
;;

type operation = Add | Sub | Mul | Div;;
let calcco x y l= 
  match (x, y, l) with
    | (x, y, Add) -> x + y
    | (x, y, Sub) -> x - y
    | (x, y, Mul) -> x * y
    | (x, 0, Div) -> failwith "Division by zero."
    | (x, y, Div) -> x / y
;;


let equal a b =
  match b with
    | a -> true
    (*a =  everything*)
;;

equal 0 0;;
equal 0 1;;

(*----------------------------------------*)
(* Sequence *)

let f x =
  Printf.printf "Calling f with value x = %d\n %!" x ;
  x * x + 2
;;

f 2;;
f 0;;

let show f v =
  Printf.printf "Function called with value %d\n %!" v ;
  f v
;;

let double x = x * 2 ;;
show double 100;;

let pshow cv f v =
  Printf.printf "Function called with value %s\n %!" (cv v) ;
  f v
;;

let double x = x * 2

let show_double = pshow string_of_int double ;;

let a = show_double 0 ;;
let b = show_double 40 ;;

(* A function taking a pair of ints. *)
let sumsquare (x,y) = x * x + y * y

(* sprintf returns a string, instead of printing it. *)
let string_of_pair (x,y) = Printf.sprintf "(%d, %d)" x y

let show_sumsquare = pshow string_of_pair sumsquare ;;
let a = show_sumsquare (1, 2) ;;
let b = show_sumsquare (10, 5) ;;

(*----------------------------------------*)
(* Inner let *)
let is_leap_year n =

  (* Test if n is a multiple of x. *)
  let multiple_of x = n mod x = 0 in

  let is_mul4 = multiple_of 4 in
  let is_mul100 = multiple_of 100 in
  let is_mul400 = multiple_of 400 in

    is_mul400 || (is_mul4 && not is_mul100)
;;

(* A top-level let to write our program. *) 
let res1 =

  (* A first inner let. *)
  let a = 10 in

  (* A second inner let, binding two variables !!at once!!. *) 
  let a = 20
  and b = a in

    (* The final result *)
    (a, b)
;;

(* This one is a top-level let. *)
let result1 =
  (* These are inner let. *)
  let a = 10
  and b = 20
  and c = true
  in

  let a = c
  and b = a
  and c = b
  in

    (a,b,c)
;;

let result2 =
  10 + 
  let x = 5 + 5 in
  let y = x * x in
    2 * y
;;

let result3 =
  "Foo is " ^ 
  let x = string_of_int (5*5) in
    x ^ " I say."
;;

let () =
  print_endline "You get" ;
  print_endline "a shiver" ;
  print_endline "in the dark" ;
  ()
;;


(*----------------------------------------*)
(* Expressions and definition *)

let fancy1 x =
  begin
    if 1>0 then
      (fun a b -> a*b )
    else
      (+)
  end
    (x-1) (x+1)
;;

fancy1 10;;

(*
let fancy2 a b c =
(* Remember concatenation? *)
"Hello " ^ 

let f =
if (* condition *) then
match (* something *) with
| ... -> (fun x -> (* bla *))
| ... -> (function 4 -> (* foo *)
| _ -> (* bar *) )
else
(* Find something relevant here. *)
in
(* Use f here *)
;;*)

