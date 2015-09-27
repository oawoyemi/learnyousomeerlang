-module(cases).
-export([beach/1, beachf/1]).

beach(Temperature) ->
  case Temperature of
    {celsius, N} when N >= 20, N =< 45 ->
      'favorable';
      {kelvin, N} when N >= 293, N =< 318 ->
        'scientifically favorable';
        {fahrenheit, N} when N >= 68, N =< 113 ->
          'favorable in the US';
          _ ->
            'avoid beach'
end.

%function heads with guards
beachf({celsius, N}) when N >= 20, N =< 45 ->
  'favorable';
  beachf({kelvin, N}) when N >= 293, N =< 318 ->
    'scientifically favorable';
  beachf(_) ->
    'avoid beach'.
