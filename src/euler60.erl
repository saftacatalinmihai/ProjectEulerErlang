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

-include_lib("eunit/include/eunit.hrl").

euler60_test_5_no_cache_test() ->
  euler60:find_first2([17,13,11,7,3], 10000, util:primes_to(10050)).

%%euler60_test_4 () ->
%%  find_first([[13,11,7,3]], #{}).
%%
%%euler60_test_5 () ->
%%  find_first([[17, 13,11,7,3]], #{}).

check([P1, P2]) ->
%%  case maps:find([P1,P2], Cache) of
%%    {ok, Check} ->
%%%%      io:format("Hit1 ~p~p~n", [P1,P2]),
%%      {Check, Cache};
%%    _ ->
%%      Check =
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
        );
%%      {Check, maps:put([P1,P2], Check)};
%%  end;

check([P1, P2 | Rest]) ->
%%  io:format("Check ~p ~p ~n", [[P1, P2 | Rest], Cache] ),
%%  case maps:find([P1, P2 | Rest], Cache) of
%%    {ok, Check_Found} ->
%%%%      io:format("Hit2 ~p~p~n", [Check_Found,[P1, P2 | Rest]]),
%%      {Check_Found, Cache};
%%    _ ->
      check([P1,P2]) and check([P2 | Rest]) and check([P1 | Rest]).
%%        {Check1, Cache1} = check([P1,P2], Cache),
%%      {Check2, Cache2} = check([P2 | Rest], Cache1),
%%      {Check3, Cache3} = check([P1 | Rest], Cache2),
%%
%%      Check = Check1 and Check2 and Check3,
%%      {Check, maps:put([P1, P2 | Rest], Check, Cache3)}.
%%  end.


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

next_candidate([],    _,_) -> [];

next_candidate([P|R], Max, Primes) when P < Max ->
%%  io:format("~p~n", [P]),
    [util:nextPrime(P, Primes) | R];

next_candidate([_|R], Max, Primes) ->
      case next_candidate(R, Max, Primes) of
        [P1|R1] -> [util:nextPrime(P1, Primes), P1 | R1];
        _ ->        overflow
      end.

find_first2(PrimesList, Max, Primes) ->
  case check(PrimesList) of
    true -> PrimesList;
    false->
      find_first2(
        next_candidate(
          PrimesList,
          Max,
          Primes
        ),
        Max,
        Primes
      )
  end.
%%
%%find_first(L, Cache) ->
%%  Candidates = sets:to_list(sets:from_list(lists:flatmap(fun(L1) -> add_prime_to_list(L1) end, L))),
%%  [[P|_]|_] = Candidates,
%%  io:format("~p ~p~n", [P, length(Candidates)]),
%%  {C3, Found} = lists:foldl(
%%    fun(PL, {C1, Acc}) ->
%%      {Check, C2} = check(PL, C1),
%%%%      io:format("Check ~p~p~n", [Check, PL]),
%%      case Check of
%%        true -> {C2, [PL | Acc]};
%%        false -> {C2, Acc}
%%      end
%%    end,
%%    {Cache, []},
%%    Candidates
%%  ),
%%%%  io:format("~p~n", [C3]),
%%  case length(Found) of
%%    0 -> find_first(Candidates, C3);
%%    _ -> Found
%%  end.