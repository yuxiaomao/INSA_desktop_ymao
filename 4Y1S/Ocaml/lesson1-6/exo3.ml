type ('a,'b) decision = 
    | Result of 'b
    | Test of ('a -> bool) * ('a, 'b) decision * ('a, 'b) decision
;;

let decision1 = Test ( (fun x -> x > 10),
                       Result "Greater than 10",
                       Result "Smaller or equal to 10" )

let decision2 = Test ( (fun x -> x < 100),
                       decision1,
                       Result "Big" )
(* decision1 is a subtree of decision2. *)

let decision3 = Test ( (fun x -> x < 0),
                       Result "Negative",
                       decision2 )
(* decision2 is a subtree of decision3 *)
;;

let rec apply_decision n = function
  | Result x -> x
  | Test(f,left,right) -> 
      if (f n) then apply_decision n left 
      else apply_decision n right
;;

apply_decision 0 decision3;;
apply_decision (-5) decision3;;
apply_decision 99 decision3;;
apply_decision 100 decision3;;


(* Exception *)
type ('a,'b) edecision =
    | Result of 'b
    | Test of ('a -> bool) * ('a, 'b) edecision * ('a, 'b) edecision
    | Error of exn
    | Catch of ('a, 'b) edecision * (exn -> bool) * ('a, 'b) edecision
;;

let edecision1 = Test ( (fun x -> x > 10),
                        Result "Greater than 10",
                        Result "Smaller or equal to 10" )

let edecision2 = Test ( (fun x -> x < 100),
                        edecision1,
                        Error Not_found )

let edecision3 = Test ( (fun x -> x < 0),
                        Error (Invalid_argument "Negative"),
                        edecision2 )

let edecision4 = Catch ( edecision3,
                         (function Not_found -> true | _ -> false),
                         Result "Too big" )

;;


let rec apply_edecision n = function
  | Result x -> x
  | Test(f,left,right) -> 
      if (f n) then apply_edecision n left 
      else apply_edecision n right
  | Error e -> raise e
  | Catch (sub, epred,branch) ->
      try 
        apply_edecision n sub
      with
        | ex ->  
            if (epred ex) then apply_edecision n branch
            else raise ex
;;

apply_edecision 0 edecision4;;
(*apply_edecision (-5) edecision4;;*)
apply_edecision 99 edecision4;;
apply_edecision 100 edecision4;;
