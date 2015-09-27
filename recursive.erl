-module(recursive).
-export([fac/1, len/1, tail_fac/1, tail_len/1, duplicate/2, tail_duplicate/2, reverse/1, tail_reverse/1]).

fac(0) -> 1;
fac(N) when N > 0 -> N*fac(N-1).

len([]) -> 0;
len([_]) -> 1;
len([_|T]) -> 1 + len(T).

%  tail_fac/1 acts like an abstraction over the tail recursive tail_fac/2 function.
tail_fac(N) -> tail_fac(N,1).
% details about the hidden accumulator of tail_fac/2 don't interest anyone,
% so we would only export tail_fac/1 from our module
tail_fac(0,Acc) -> Acc;
tail_fac(N,Acc) when N > 0 -> tail_fac(N-1, N*Acc).

tail_len(L) -> tail_len(L,0).

tail_len([],Acc) -> Acc;
tail_len([_|T], Acc) -> tail_len(T, Acc+1).

duplicate(0,_) ->
  [];
duplicate(N,Term) when N > 0 ->
  [Term|duplicate(N-1, Term)].

tail_duplicate(N,Term) -> tail_duplicate(N, Term, []).

tail_duplicate(0,_,List) ->
  List;
tail_duplicate(N, Term, List)  when N > 0 ->
  tail_duplicate(N-1, Term, [Term|List]).

reverse([]) -> [];
reverse([H|T]) -> reverse(T) ++ [H].

tail_reverse(List) -> tail_reverse(List, []).

tail_reverse([],Acc) -> Acc;
tail_reverse([H|T], Acc) -> tail_reverse(T, [H|Acc]).
