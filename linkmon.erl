-module(linkmon).
-compile(export_all).

myproc() ->
  timer:sleep(5000),
  exit(reason).

%take an integer N, start N processes linked one to the other.
% In order to be able to pass the N-1 argument to the next 'chain' process (which calls spawn/1),
% I wrap the call inside an anonymous function so it doesn't need arguments anymore.
% Calling spawn(?MODULE, chain, [N-1]) would have done a similar job.
chain(0) ->
  receive
    _ -> ok
  after 2000 ->
      exit("chain dies here")
  end;
  chain(N) ->
    Pid = spawn(fun() -> chain(N-1) end),
    link(Pid),
    receive
      _ -> ok
    end.

start_critic() ->
  spawn(?MODULE, critic, []).

% supervisor
start_critic2() ->
  spawn(?MODULE, restarter, []).

  restarter() ->
    process_flag(trap_exit, true),
    Pid = spawn_link(?MODULE, critic2, []),
    %register(critic, Pid),
    receive
      {'EXIT', Pid, normal} -> % not a crash
      ok;
      {'EXIT', Pid, shutdown} -> % manual termination, not a crash
      ok;
      {'EXIT', Pid, _} ->
    restarter()
  end.

judge(Pid, Band, Album) ->
  Pid ! {self(), {Band, Album}},
  receive
    {Pid, Critism} -> Critism
  after 2000 ->
    timeout
  end.

  judge2(Band, Album) ->
    Ref = make_ref(),
    critic ! {self(), Ref, {Band, Album}},
    receive
      {Ref, Critism} -> Critism
    after 2000 ->
      timeout
    end.

  critic() ->
    receive
      {From, {"Rage Against the Turing Machine", "Unit Testify"}} ->
        From ! {self(), "They are great!"};
      {From, {"Johnny Crash", "The Token Ring of Fire"}} ->
        From ! {self(), "Simply incredible"};
      {From, {_Band, _Album}} ->
        From ! {self(), "They are terrible!"}
    end,
    critic().

    critic2() ->
      receive
        {From, Ref, {"Rage Against the Turing Machine", "Unit Testify"}} ->
          From ! {Ref, "They are great!"};
        {From, Ref, {"Johnny Crash", "The Token Ring of Fire"}} ->
          From ! {Ref, "Simply incredible"};
        {From, Ref, {_Band, _Album}} ->
          From ! {self(), "They are terrible!"}
      end,
      critic2().
