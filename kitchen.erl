-module(kitchen).
-compile(export_all).


fridge1() ->
  receive
    {From, {store, _Food}} ->
      From ! {self(), ok},
      fridge1();
    {From, {take, _Food}} ->
      From ! {self(), not_found},
      fridge1();
    terminate ->
      ok
  end.
% abstract process creation
% ?MODULE is a macro returning current module name
% logging and additional processes may also be initialised here.
start(FoodList) ->
  spawn(?MODULE, fridge2, [FoodList]).

fridge2(FoodList) ->
  receive % waits until a message is received
    {From, {store, Food}} ->
      From ! {self(), ok},
      %recursive call -  it will then be possible to retrieve the same item
      fridge2([Food|FoodList]);
    {From, {take, Food}} ->
      case lists:member(Food, FoodList) of
        true ->
          From ! {self(), {ok, Food}},
          fridge2(lists:delete(Food, FoodList));
        false ->
          From ! {self(), not_found},
          fridge2(FoodList)
      end;
    terminate ->
      ok
  end.

store(Pid, Food) ->
  % side effect using self?
  % self is only required to receive return message so ok to encapsulate within function
  Pid ! {self(), {store, Food}},
  receive %message received back from called Pid process
    {Pid, Msg} -> Msg
  end.

take(Pid, Food) ->
  Pid ! {self(), {take, Food}},
  receive  %message received back from called Pid process
    {Pid, Msg} -> Msg
  end.

  store2(Pid, Food) ->
    Pid ! {self(), {store, Food}},
    receive
      {Pid, Msg} -> Msg
    after 3000 ->
      timeout
    end.

  take2(Pid, Food) ->
    Pid ! {self(), {take, Food}},
    receive  %message received back from called process
      {Pid, Msg} -> Msg
    after 3000 ->
      timeout
    end.
