open Gamebase

(* These types are abstract in game.mli *)

type state = int * player

type move = int

type result = Win of player

(* Printers *)
let state2s (n,p) = Printf.sprintf "Current = %d  // %s to play" n (player2s p)

let move2s n = Printf.sprintf " +%d" n

let result2s (Win p) = (player2s p) ^ " wins"

(* Reader *)
let readmove s = try Some (int_of_string s) with _ -> None

(* You have to provide these. *)
let initial = (0,Comput)

let turn = function
  | (_,Human) -> Human
  | (_,Comput) -> Comput

let is_valid s m = 
  match s with
  | (n,_) -> ((m<=3)&&(m>=1)&&(n+m)<=30)

let play s m =
  match s with
  | (n,pl) -> (n+m, next pl)

let all_moves s =
  3::2::1::[]

let result = function
  | (30,pl) -> Some (Win (pl))
  | (_,pl) -> None

(* This type was given in game.mli.
 * We have to repeat it here. *)
type comparison = Equal | Greater | Smaller

let compare player old_result new_result =
  match old_result,new_result with
  | Win Human, Win Human -> Equal
  | Win Comput, Win Comput -> Equal
  | Win _, Win p2 -> 
    if (player=p2) then Greater
    else Smaller

let worst_for player = Win (next player)

