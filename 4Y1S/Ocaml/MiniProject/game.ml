(*#use "gamebase.ml";;*)
open Gamebase

(* These types are abstract in game.mli *)
type gamecase = Piece of player | No_piece

type gameplan = gamecase array array

type state = gameplan * player

type move = int

type result = Win of player | Even_game

(* Printers *)
let gamecase2s c =
  match c with
    | Piece Comput -> Printf.sprintf " C"
    | Piece Human -> Printf.sprintf " H"
    | No_piece -> Printf.sprintf "  "

let gameplan2s gp =
  matrix2s gp gamecase2s

let state2s (gp,pl) =
  Printf.sprintf "Current = \n-0--1--2--3--\n%s  \n %s's turn" 
    (gameplan2s gp) (player2s pl)

let move2s n = Printf.sprintf " +%d" n

let result2s res = 
  match res with
    | Win p ->(player2s p) ^ " wins"
    | Even_game -> "Even game"

(* Reader *)
let readmove s = try Some (int_of_string s) with _ -> None

(* | * - *)
let initial = (
  Array.make_matrix 4 4 No_piece,
  Comput)

let turn = function
  | (_,Human) -> Human
  | (_,Comput) -> Comput

let is_valid (gp,_) m = 
  if (m>=0)&&(m<Array.length gp.(0)) then
    match gp.(0).(m) with
      | No_piece -> true
      | _ -> false
  else
    false

exception Found_array of int
let play (gp,pl) m =
  try
    for pos = 0 to Array.length gp - 1 do
      if (fun x-> x!=No_piece) gp.(pos).(m) then raise (Found_array (pos-1))
    done;
    raise (Found_array (Array.length gp - 1))
  with
      Found_array x -> 
        if (x==(-1)) then 
          raise (Failure "[play]move impossible.")
        else
          let gp2 = clone_matrix gp in
            gp2.(x).(m) <- (Piece pl);
            (gp2, next pl)


(* length < 10*)
let rec build_moves = function
  | 0 -> 0::[]
  | n -> n:: (build_moves (n-1))

let all_moves s =
  build_moves 10


(** Result begin**)
(* list_gamecase -> if 4 same?*)
let rec resultlist4 l =
  match l with
    | Piece x1 :: Piece x2 ::Piece x3:: tl -> 
        if ((x1==x2)&&(x1==x3)) then Some(Win x1)
        else resultlist4 (Piece x2::Piece x3:: tl)
    | No_piece :: tl -> resultlist4 tl
    | _ -> None

(* gameplan vector -> list, include x,y *)
let rec construct_list gp x y dx dy = 
  let max_x = Array.length gp in
  let max_y = Array.length gp.(0) in
    if (x>=0)&&(x<max_x)&&(y>=0)&&(y<max_y) then
      begin
        (gp.(x).(y))::(construct_list gp (x+dx) (y+dy) dx dy)
      end
    else
      []

exception Found_result of result

(* top-down *)
let resulttd gp =
  try
    for y = 0 to Array.length gp.(0) -1 do
      match resultlist4 (construct_list gp 0 y 1 0) with
        | Some res -> raise (Found_result (res))
        | None -> ()
    done;
    None
  with
      Found_result res -> Some res

(* left-right *)
let resultlr gp =
  try
    for x = 0 to Array.length gp -1 do
      match resultlist4 (construct_list gp x 0 0 1) with
        | Some res -> raise (Found_result (res))
        | None -> ()
    done;
    None
  with
      Found_result res -> Some res


(* topleft - downright*)
let resulttldr gp =
  try
    for x = 0 to Array.length gp -1 do
      match resultlist4 (construct_list gp x 0 1 1) with
        | Some res -> raise (Found_result (res))
        | None -> ()
    done;
    for y = 1 to Array.length gp.(0) -1 do
      match resultlist4 (construct_list gp 0 y 1 1) with
        | Some res -> raise (Found_result (res))
        | None -> ()
    done;
    None
  with
      Found_result res -> Some res


(* downleft -topright *)
let resultdltr gp =
  try
    let max_x = Array.length gp - 1 in
      for x = 0 to max_x do
        match resultlist4 (construct_list gp x 0 (-1) 1) with
          | Some res -> raise (Found_result (res))
          | None -> ()
      done;
      for y = 1 to Array.length gp.(0) -1 do
        match resultlist4 (construct_list gp max_x y (-1) 1) with
          | Some res -> raise (Found_result (res))
          | None -> ()
      done;
      None
  with
      Found_result res -> Some res


(* true if no next move*)
let end_game state =
  (List.filter (is_valid state) (all_moves state)) == []


let result state = 
  match state with
    | (gp,_) -> 
        match resulttd gp with
          | Some x -> Some x
          | None -> 
              match resultlr gp with
                | Some x -> Some x
                | None -> 
                    match resulttldr gp with
                      | Some x -> Some x
                      | None ->
                          match resultdltr gp with
                            | Some x -> Some x
                            | None ->
                                if (end_game state) then Some(Even_game)
                                else None

(** Result end **)

(* This type was given in game.mli.
 * We have to repeat it here. *)
type comparison = Equal | Greater | Smaller

let compare player old_result new_result =
  match old_result,new_result with
    | Win Human, Win Human -> Equal
    | Win Comput, Win Comput -> Equal
    | Even_game , Even_game -> Equal
    | Win p, Even_game ->
        if (player=p) then Smaller
        else Greater
    | _, Win p2 -> 
        if (player=p2) then Greater
        else Smaller

let worst_for player = Win (next player)

