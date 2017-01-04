(* --------------------- *)
(* Compilation *)


let showdir () = 
  let f_list = Sys.readdir (Sys.getcwd ()) in
    Array.sort compare f_list;
    Array.iter (fun a-> Printf.printf "%s \n" a) f_list;
    Printf.printf "%!"
;;

let () = showdir ();; 

(* ------------------- *)
(* Exceptions *)
let a = Not_found
let b = Failure "arrh"
let c = End_of_file
let d = Division_by_zero
;;

(* let e = raise Not_found;; *)

let a () = Not_found
let b () = raise Not_found
;;

raise;;
let failwith msg = raise (Failure msg);;
exception Horrible_error;;
exception Bad_bad_thing of int * string;;
(* Function that returns Some x if the list argument starts with x, or None if the list is empty. *)
let get_head l =
  try Some (List.hd l)
  with Failure _ -> None
  (* Note: this function looks much better with a good old pattern-matching on lists. *)
;;

let test_raise x =
  try
    if x < 0 then raise Not_found
    else if x = 0 then failwith "Zero"
    else if x > 10 then raise Horrible_error
    else if x > 100 then raise (Bad_bad_thing (x, "Too big."))
    else [ string_of_int x ]
  with
    | Not_found -> []
    | Failure s -> [s]
;;

test_raise (-1);;
test_raise (0);;
(* test_raise (11);; *)
(* test_raise (111);; *)
test_raise (5);;


(* excercise exceptions *)
let call f arg =
  try f arg
  with
    (*|Failure s -> 
      Printf.printf " Failure %s%!" (s); 
      raise (Failure s);*)
    |e -> Printf.printf "%s %!" (Printexc.to_string e); raise e;
;;

(* call List.hd [];; *)
(* call (fun x -> 5/ x) 0;;*)


type 'a result = Ok of 'a | Error of exn;;

let eval f arg = 
  try 
    Ok (f arg);
  with 
    | exn -> Error exn
;;

(** let check_all f alist**)
let rec check_all f alist =
  match alist with
    | [] -> true
    | (a,b)::tl -> 
        if ((eval f a) = b) then check_all f tl
        else false
;;

check_all List.hd [];;
check_all List.hd [ ([1], Ok 1) ];;
check_all List.hd [ ([1], Ok 2) ];;
check_all List.hd [ ([1], Ok 1) ; ([4;3;2;1], Ok 4) ];;
check_all List.hd [ ([1], Ok 1) ; ([], Error (Failure "hd")) ];;

(* Controled effects *)

let calc x =
  Printf.printf "Computing x*x with x = %d\n%!" x ;
  x * x
;;

(** WOOOOOOO le function apres creation memoire **)
let cache f = 
  let memory = Hashtbl.create 20 in
    function
      | arg ->
          try 
            let resu = Hashtbl.find memory arg in
              resu
          with
            | Not_found -> 
                let resu = f arg in
                  Hashtbl.add memory arg resu;
                  resu
;;

let test_cache () =

  (* The "computing..." message is printed ten times. *)
  Printf.printf "\n I define l1:\n%!" ;  
  let l1 = List.map calc [ 3 ; 2 ; 2 ; 3 ; 1 ; 2 ; 3 ; 2 ; 2 ; 1 ] in

    (* The "computing..." message should be printed only three times. *)
    Printf.printf "\n I define l2:\n%!" ;  
    let l2 = List.map (cache calc) [ 3 ; 2 ; 2 ; 3 ; 1 ; 2 ; 3 ; 2 ; 2 ; 1 ] in

      (* Check that l1 equals l2 *)
      Printf.printf "l1 = l2 ? %b\n%!" (l1 = l2) ;
      ()
;;
test_cache();;


(* ------------------------------- *)
(* Exercise laziness *)
(** MUTABLE **)

type 'a tlazy = {
  mutable laz : 'a option;
  compute : unit -> 'a;
}

let flazy compu =
  {laz = None;
   compute = compu}
;;

let get_value l = 
  match l.laz with
    | None -> 
        let res = l.compute () in
          l.laz <- Some res;
          res
    | Some v -> v
;;

let arglazy f arg = flazy (fun () -> f arg);;

(*------------------------------------*)


let intshow vlazy = 
  Printf.printf "%d \n%!" (get_value vlazy);
;;


let laz1 = arglazy calc 1
and laz2 = arglazy calc 2
let _ = intshow laz1 ;;
let _ = intshow laz1 ;;
let _ = intshow laz1 ;;
let _ = intshow laz2 ;;
let _ = intshow laz2 ;;
let _ = intshow laz2 ;;

let rec build_list_tlazy tl= function
  | 0 -> tl
  | n -> build_list_tlazy ((n,arglazy calc n)::tl) (n-1)
;;

let l_laz = build_list_tlazy [] 10;;

exception N_not_found;;

let rec choose n biglist = 
  match biglist with
    | [] -> 
        raise N_not_found
    | (nb,nb_tlazy)::tl ->  
        if (nb = n) then get_value (nb_tlazy)
        else choose n tl
;;

let choose n biglist = get_value (List.assoc n biglist);;
let _ = choose 5 l_laz;;
let _ = choose 5 l_laz;;


(*------------------------------------*)
(** value restriction **)

let single x = [x]
let cached_single = cache single
;;
let res1 = cached_single "foo" ;;
cached_single ;;

(* parce que dans le hashtbl , cashe, 
   la table associe a la fonction sigle a stocke les valeurs string .?*)

exception Arg_refuse;;
let forbid x = function
  | n -> 
      if (x=n) then raise Arg_refuse
      else n
;;

let f = forbid 99;;
f 10;;
f 20;;
(*f 99;;*)
f;;
(** Find a way to illustrate the value restriction using forbid. ????? **)


let mk_pair a b = (a,b);;
let mk0 = mk_pair 0;;
(* Check the type of f. Would it be safe to be polymorphic? *)
(** Euh pourquoi pas **)


let equals a b = (a = b)
let is_empty = equals [];;
(* Same question *)
(** mais je pense que ici c'est pas obligatoire....**)

(* function / application *)
let fix_mk0 x = mk_pair 0 x
let fix_is_empty x = equals [] x
;;
