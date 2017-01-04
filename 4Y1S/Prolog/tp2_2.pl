% Dispatch Init
dispatch(_,[],[],[]).

% Dispatch Regle
dispatch(X,[A|Tl],[A|Infeg],Sup) :-
  A=<X,
  dispatch(X,Tl,Infeg,Sup).
dispatch(X,[A|Tl],Infeg,[A|Sup]) :-
  A>X,
  dispatch(X,Tl,Infeg,Sup).

% Quicksort Init
quicksort([],[]).

% Quicksort
quicksort([A|Tl],Sorted) :-
  dispatch(A,Tl,Infeg,Sup),
  quicksort(Infeg,SortedInfeg),
  quicksort(Sup,SortedSup),
  append(SortedInfeg,[A|SortedSup],Sorted).


% Quicksort2 
quicksort2([],L,L).
quicksort2([A|Tl],Aux,Sorted) :-
  dispatch(A,Tl,Infeg,Sup),
  quicksort2(Sup,Aux,SortedSup),
  quicksort2(Infeg,[A|SortedSup],Sorted).
