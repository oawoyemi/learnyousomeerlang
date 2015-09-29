-module(recursionqs).
-export([quicksort/1,lc_quicksort/1]).

quicksort([]) -> [];
quicksort([Pivot|T]) ->
  {Smaller,Larger} = partition(Pivot,T,[],[]),
  quicksort(Smaller) ++ [Pivot] ++ quicksort(Larger).

partition(_, [], Smaller, Larger) -> {Smaller, Larger};
partition(Pivot, [H|T], Smaller, Larger) ->
  if H =< Pivot -> partition(Pivot, T, [H|Smaller], Larger);
     H > Pivot -> partition(Pivot, T, Smaller, [H|Larger])
  end.

% quicksort based on list comp, easier to read but traverses the list twice
lc_quicksort([]) -> [];
lc_quicksort([Pivot|T]) ->
  lc_quicksort([Smaller || Smaller <- T, Smaller =< Pivot])
  ++ [Pivot] ++
  lc_quicksort([Larger || Larger <- T, Larger > Pivot]).
