-module(exceptions).
-compile(export_all).

%exceptions:errors(fun() -> erlang:error("Die!") end).
%>{error,caught,"Die!"}
throws(F) ->
  try F() of
    _ -> ok
  catch
    Throw -> {throw, caught, Throw}
  end.

black_knight(Attack) when is_function(Attack, 0) ->
  try Attack() of
    _-> "None shall pass."
    catch
      throw:slice -> "It is but a scratch.";
      error:cut_arm -> "I've had worse.";
      exit:cut_leg -> "Come on you pansy!";
      _:_ -> "Just a flesh wound."
    end.


  talk() -> "blah blah".
