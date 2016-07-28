%%%-------------------------------------------------------------------
%%% @author mihai
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jul 2016 11:07 AM
%%%-------------------------------------------------------------------
-module(euler60).
-author("mihai").

-compile(export_all).

check([P1, P2], Cache) ->
  case maps:find([P1,P2], Cache) of
    {ok, Check} ->
%%      io:format("Hit1 ~p~p~n", [P1,P2]),
      {Check, Cache};
    _ ->
      Check =
        util:isPrime(
          list_to_integer(
            string:concat(
              integer_to_list(P1),
              integer_to_list(P2)
            )
          )
        )
        and
        util:isPrime(
          list_to_integer(
            string:concat(
              integer_to_list(P2),
              integer_to_list(P1)
            )
          )
        ),
      {Check, maps:put([P1,P2], Check, Cache)}
  end;

check([P1, P2 | Rest], Cache) ->
  case maps:find([P1,P2], Cache) of
    {ok, Check_Found} ->
%%      io:format("Hit2 ~p~p~n", [Check_Found,[P1, P2 | Rest]]),
      {Check_Found, Cache};
    _ ->
      {Check1, _Cache1} = check([P1,P2], Cache),
      {Check2, _Cache2} = check([P2 | Rest], Cache),
      {Check3, _Cache3} = check([P1 | Rest], Cache),

      Check = Check1 and Check2 and Check3,
      {Check, maps:put([P1, P2 | Rest], Check, Cache)}
  end.


first_five_primes() -> [17, 13,11,7,3].

add_prime_to_list([P1,P2,P3,P4]) ->
  Next_prime = util:nextPrime(P1),
  [
    [Next_prime, P2, P3, P4],
    [Next_prime, P1, P3, P4],
    [Next_prime, P1, P2, P4],
    [Next_prime, P1, P2, P3]
  ];

add_prime_to_list([P1,P2,P3,P4,P5]) ->
  Next_prime = util:nextPrime(P1),
  [
    [Next_prime, P2, P3, P4, P5],
    [Next_prime, P1, P3, P4, P5],
    [Next_prime, P1, P2, P4, P5],
    [Next_prime, P1, P2, P3, P5],
    [Next_prime, P1, P2, P3, P4]
  ].

find_first(L, Cache) ->
  Candidates = sets:to_list(sets:from_list(lists:flatmap(fun(L1) -> add_prime_to_list(L1) end, L))),
  [[P|_]|_] = Candidates,
  io:format("~p ~p~n", [P, length(Candidates)]),
  {C3, Found} = lists:foldl(
    fun(PL, {C1, Acc}) ->
      {Check, C2} = check(PL, C1),
%%      io:format("Check ~p~p~n", [Check, PL]),
      case Check of
        true -> {C2, [PL | Acc]};
        false -> {C2, Acc}
      end
    end,
    {Cache, []},
    Candidates
  ),
%%  io:format("~p~n", [C3]),
  case length(Found) of
    0 -> find_first(Candidates, C3);
    _ -> Found
  end.