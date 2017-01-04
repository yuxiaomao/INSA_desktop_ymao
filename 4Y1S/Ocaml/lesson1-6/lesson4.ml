(*-----------------------------------*)
(* Records *)
(* This defines a record type. *)
type coordinates =
    { long: float ;
      lat:  float }
;;

(* This defines only an alias. *)
type path = coordinates list
;;

(* Another record *)
type region =
    { region_name: string ;
      borders: path ;
      has_coastline: bool }
;;

(** Functions are first-class, they can appear in records. **)
type test =
    { (* A function which should be tested. *)
      fonc: (int -> int) ;

      (* An argument, which will be given to the function. *) 
      arg: int ;

      (* The expected result. *)
      expect: int }
;;

let point1 = { long = -0.3 ;
               lat  = 42.5 }
;;
let point2 = { point1 with long = -1.0 }
;;
(* 3 expressions equals*)
let get_lat c = c.lat
;;
let get_lat { lat = ll } = ll
;;
let get_lat { lat } = lat
;;
let get_all { long ; lat } = (long, lat)
;;
(* Checks if a region is well defined: it must have a region name and at least one border. *)
let is_good = function
  | { region_name = "" } -> false
  | { borders = [] } -> false
  | _ -> true
;;
let is_good = function
  | { region_name = "" } | { borders = [] } -> false
  | _ -> true
;;

(* Exercise records*)
let apply = function
  | x-> (x.fonc x.arg = x.expect)
;;

let apply = function
  | { fonc = f ; arg = a ; expect = e } -> (f a = e)
;;

let apply x = (x.fonc x.arg = x.expect)
;;
apply {fonc= ((+) 1); arg = 2; expect = 3};;
apply {fonc= ((+) 1); arg = 2; expect = 2};;


(*-----------------------------------*)
(* Parameterized types *)
(* A parameterized record type. *)
type 'a test =
    { fonc: ('a -> int) ;
      arg: 'a ;
      expect: int }
;;

(* Exercise records 2 *)
let apply x = (x.fonc x.arg = x.expect)
;;

apply {fonc= ((+) 1); arg = 2; expect = 3};;
apply {fonc= ((+) 1); arg = 2; expect = 2};;
apply {fonc= (fun x -> if x then 1 else (-1)); arg = false; expect = 3};;
apply {fonc= (fun x -> if x then 1 else (-1)); arg = false; expect = (-1)};;


type ('a, 'b) test =
    { fonc: (('a * 'b) -> int) ;
      arg: ('a * 'b) ;
      expect: int }
;;

(* Exercise records 3 *)
let apply x = (x.fonc x.arg = x.expect)
;;

apply {fonc= (fun (x,y) -> (x+y)); arg = (2,5); expect = 7};;


(*-----------------------------------*)
(* Array *)

let john = Array.make 100 true;;
john.(99);;
john.(1) <- false;;
john;;
let foo a i = a.(i);;
let bar a i v = a.(i) <- v;;

(*-----------------------------------*)
(* Mutable records *)
type player =
    { name: string ;
      age: int ;
      mutable points: int }
;;

let show_player player =
  Printf.printf "Nom :%s\n" player.name ;
  Printf.printf "Age :%d\n" player.age ;
  Printf.printf "Score :%d\n %!" player.points
;;

let new_player name_of_player age_of_player = 
  let p = {name = name_of_player;
           age = age_of_player;
           points = 0} in
    p
;;

let add_points player points_add = 
  player.points <- player.points + points_add
;;

let player1 = new_player "aoo" 18;;
let player2 = new_player "boo" 15;;
add_points player1 10;;
add_points player2 5;;
add_points player1 30;;
add_points player2 45;;
show_player player1;;
show_player player2;;

type iplayer =
    { iname: string ;
      iage: int ;
      ipoints: int }

let show_iplayer player =
  Printf.printf "Nom :%s\n" player.iname ;
  Printf.printf "Age :%d\n" player.iage ;
  Printf.printf "Score :%d\n %!" player.ipoints
;;

let new_iplayer name_of_player age_of_player = 
  let p = {iname = name_of_player;
           iage = age_of_player;
           ipoints = 0} in
    p
;;

let add_ipoints player points_add = 
  {iname = player.iname;
   iage = player.iage;
   ipoints = ( (player.ipoints) + points_add)}
;;

let test () =
  (* Create an iplayer and add some points. *)
  let p1_a = new_iplayer "coo" 10 in
  let p1_b = add_ipoints p1_a 50 in
  let p1_c = add_ipoints p1_b 20 in
    show_iplayer p1_c
;;

test ();;


(* type 'a ref = { contents: 'a } *)
let create x = { contents = x };;
let read rf = rf.contents;;
let write rf v = rf.contents <- v;;

let test () = 
  let foo = create 10 in
    Printf.printf "Read :%d\n %!" (read foo);
    write foo 20;
    Printf.printf "Read :%d\n %!" (read foo);
;;

test ();;

(*
let ref x = { contents = x };;
let (!) rf = rf.contents;;
let (:=) rf v = rf.contents <- v;;
*)

let test () = 
  let foo = ref 10 in
    Printf.printf "Read :%d\n %!" (!foo);
    foo:= 20;
    Printf.printf "Read :%d\n %!" (!foo);
;;
test ();;

(* Exercise *)
let gen =
  let count = ref 0 in
    fun () ->
      count := !count + 1 ;
      !count
;;
gen ();;

(* ---------------------------- *)
(* Variant datatypes *)
type color = White | Yellow | Green | Blue | Red;;
type role = Player | Referee;;
type role = Player of color * int | Referee;;
let role1 = Referee
let role2 = Player (Green, 8)
let role3 = Player (Yellow, 10)
let role4 = Player (Green, 10)


;;
let get_number = function
  | Referee -> 0
  | Player (_, nb) -> nb
;;
type people =
    { name: string ;
      role: role ;
      age: int }
;;

let same_team p1 p2 =
  match (p1.role,p2.role) with
    | (_,Referee) -> false
    | (Referee,_) -> false
    | (Player(c1,_),Player(c2,_)) -> c1 = c2
;;
let test = 
  let people1 = {name = "people1";
                 role = role1;
                 age = 23} in
  let people2 = {name =  "people2";
                 role = role2;
                 age = 24} in
  let people3 = {name = "people3";
                 role = role3;
                 age = 25} in
  let people4 = {name = "people4";
                 role = role4;
                 age = 26} in
    Printf.printf "Resu %b\n %!" (same_team people1 people2);
    Printf.printf "Resu %b\n %!" (same_team people3 people2);
    Printf.printf "Resu %b\n %!" (same_team people4 people2);
;;

let is_number p1 nb = 
  match p1.role with
    | Player(_, n) -> nb=n
    | _ -> false
;;
let test = 
  let people1 = {name = "people1";
                 role = role1;
                 age = 23} in
  let people2 = {name =  "people2";
                 role = role2;
                 age = 24} in
  let people3 = {name = "people3";
                 role = role3;
                 age = 25} in
    Printf.printf "Resu %b\n %!" (is_number people1 1);
    Printf.printf "Resu %b\n %!" (is_number people2 1);
    Printf.printf "Resu %b\n %!" (is_number people2 8);
    Printf.printf "Resu %b\n %!" (is_number people3 9);
;;

(* ------------------------ *)
(* Parameterized and recursive variants *)
type 'a mylist = Empty | Cell of 'a * 'a mylist;;
let myhd = 
  function
    | Empty -> failwith "empty list"
    | Cell(hd, _) -> hd
;;
let mytl = 
  function
    | Empty -> failwith "empty list"
    | Cell(_, tl) -> tl
;;

failwith  ;;

let rec mylength long= 
  function
    | Empty -> long
    | Cell(_,tl) -> mylength (long+1) tl
;;

mylength 0 (Cell( 10, Cell(20, Empty))) ;;

(* Builtin list *)
(* type 'a list = [] | (::) of 'a * 'a list *)
let hd = function
  | [] -> failwith "empty list"
  | a::_ -> a
;;
let tl = function
  | [] -> failwith "empty list"
  | _::tl -> tl
;;
let rec length long= function
  | [] -> long
  | _::tl -> length (long+1) tl 
;;

(* Option type *)
(* type 'a option = None | Some of 'a;;*)
let ohd = function
  | [] -> None
  | a::_ -> Some a
;;

let otl = function
  | [] -> None
  | _::x -> Some x
;;

otl [0];;

(* -------------------------- *)
(* Exercises on lists *)
let rec get_referees_inv acc people_l = 
  match people_l with
    | [] -> acc
    | r:: tl -> match r.role with
      | Referee -> get_referees_inv (r::acc) tl
      | _ -> get_referees_inv acc tl
;;
(* inverse list referees*)
let rec inv_list l l_after= 
  match l with
    | [] -> l_after
    | a::tl -> inv_list tl (a::l_after)
;;
let get_referees acc people_l = 
  inv_list (get_referees_inv acc people_l) []
;;

let people1 = {name = "people1";
               role = role1;
               age = 23} ;;
let people2 = {name =  "people2";
               role = role2;
               age = 24} ;;
let people3 = {name = "people3";
               role = role3;
               age = 25} ;;
let people4 = {name = "people4";
               role = role4;
               age = 26} ;;
let list_people = people2 :: [people1] ;;
let list_people = people3 :: list_people ;;
let list_people = people4 :: list_people ;;
let test =
  get_referees [] list_people;;

(* not yet end get_younger + find_colir *)
(* ---------------- *)

(* generic functions *)
let rec filter pred alist acc=
  match alist with
    | [] -> acc
    | a::tl -> 
        if pred a then filter pred tl (a::acc)
        else filter pred tl acc
;;
filter (fun x -> x mod 2 = 0) [ 1 ; 2 ; 3 ; 4 ; 5 ; 6] [];;

(* not yet end find + has_color + filter +find *)






