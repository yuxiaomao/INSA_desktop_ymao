open Game
open Functory.Network
open Functory.Network.Same



let compare_mr current_player (m1,r1) (m2,r2) = 
  match compare current_player r1 r2 with
    | Smaller-> (m1,r1)
    | Equal 
    | Greater -> (m2,r2)

let best_move = 
  let memory = Hashtbl.create 20 in
  let find_hashtbl f=
    function
      | arg ->
          try 
            let resu = Hashtbl.find memory arg in
              resu
          with
            | Not_found -> 
                let resu = f arg in
                  Hashtbl.add memory arg resu;
                  (* Printf.printf "Add resu\n %!";*)
                  resu
  in
  let rec rec_best_move state =
    let rec construction_best_mr s m_list =
      match m_list with
        | [m] ->
            let (_,r) = find_hashtbl rec_best_move (play s m) in
              (m,r)
        | m::tl ->
            let bes_tl = (construction_best_mr s tl) in
            let (_,r) =  find_hashtbl rec_best_move (play s m) in
              compare_mr (turn state) (m,r) bes_tl 
        | [] -> raise (Failure "[Game_ia]Err_List_move_vide")
    in
      match result state with
        | Some res -> 
            (None, res)
        | None -> 
            let (res_m,res_r) = 
              construction_best_mr state 
                (List.filter (is_valid state) (all_moves state))
            in
              (Some res_m, res_r)
  in
    function
      | s -> 
          match result s with
            | Some res -> 
                (None, res)
            | None -> 
                let ms_list = List.map (fun x-> (Some x,play s x)) (List.filter (is_valid s) (all_moves s)) in
                let my_map (m1,state) = 
                  try 
                    let (_,r2) = find_hashtbl rec_best_move state in
                      (m1,r2)
                  with
                      e->Printf.printf "[G_ia_err]-----%s\n%!" (Printexc.to_string e)  ;
                        raise e
                in
                let (res_m,res_r) = 
                  map_fold_ac 
                    ~f: my_map
                    ~fold: (compare_mr (turn s))
                    (None, Game.worst_for (turn s))
                    ms_list
                in
                  (res_m, res_r)
