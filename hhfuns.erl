-module(hhfuns).
-compile(export_all).

one() -> 1.
two() -> 2.
%hhfuns:add(one,two). - exception error: bad function one - interpreted as atoms
%hhfuns:add(1,2) - exception error: bad function 1 - attempting to call function on nums
add(X,Y) -> X() + Y().

increment([]) -> [];
increment([H|T]) -> [H+1|increment(T)].

decrement([]) -> [];
decrement([H|T]) -> [H-1|decrement(T)].

%higher order functions
% call as hhfuns:map(fun hhfuns:incr/1, [1,2,3]).
% call with anonymous function:
% hhfuns:map(fun(X) -> X + 1 end, [1,2,3]).
%> [2,3,4]
map(_, []) -> [];
map(F, [H|T]) -> [F(H)|map(F,T)].

inc(X) -> X+1.
dec(X) -> X-1.
%closure
base(A) ->
  B = A + 1,
  F = fun() -> A * B end,
  F().

  %closure - inherited scope is bound to function wherever executed
  a() ->
    Secret = "pony",
    fun() -> Secret end.

b(F) ->
  "a/0's password is "++F().

 %anonymous functions are useful for passing around state

%PowerOfTwo = fun(X) -> math:pow(Base,X) end.
%map(PowerOfTwo, [1,2,3,4]).
%>[2.0,4.0,8.0,16.0]

% hhfuns:filter(fun(X) -> X rem 2 == 0 end, Numbers).
%> [2,4,6,8,10]
filter(Predicate, L) -> lists:reverse(filter(Predicate, L, [])).

filter(_, [], Acc) -> Acc;
filter(Pred, [H|T], Acc) ->
  case Pred(H) of
    true -> filter(Pred, T, [H|Acc]);
    false -> filter(Pred, T, Acc)
  end.

%find the max of a list
max([H|T]) -> max2(T, H).

max2([], Max) -> Max;
max2([H|T], Max) when H > Max -> max2(T,H);
max2([_|T], Max) -> max2(T, Max).

%% find the minimum of a list
min([H|T]) -> min2(T,H).

min2([], Min) -> Min;
min2([H|T], Min) when H < Min -> min2(T,H);
min2([_|T], Min) -> min2(T, Min).

sum([]) -> 0;
sum(L) -> sum(L,0).

sum([], Sum) -> Sum;
sum([H|T],Sum) -> sum(T, H + Sum).

%[H|T]=[1,2,3,17,5,6].
%hhfuns:fold(fun(A,B) when A > B -> A; (_,B) -> B end, H, T).
%>17
fold(_, Start, []) -> Start;
fold(F, Start, [H|T]) -> fold(F, F(H,Start),T).
