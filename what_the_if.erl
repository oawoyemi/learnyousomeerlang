-module(what_the_if).
-export([heh_fine/0, oh_god/1]).
%The rationale behind if is quite simple: 
% it was added to the language as a short way to have guards
% without needing to write the whole pattern matching part when it wasn't needed.
heh_fine() ->
  if 1 =:= 1 ->
    works
  end,
  if 1 =:= 2; 1 =:= 1 ->
    works
  end,
  if 1 =:= 2, 1 =:= 1 ->
    fails
  end.

  oh_god(N) ->
    if N =:= 2 -> might_succeed;
      true -> always_does %% this is erlang's if/else
    end.
