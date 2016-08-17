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

test() ->
     ?assertEqual({13,5197,5701,6733,8389}, find_first()).

check(P1, P2) ->
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
        ).

valid(_, [], Acc) ->
    sets:from_list(Acc);

valid(Prime, [P|R], Acc)  when P < Prime ->
  valid(Prime, R, Acc);

valid(Prime, [P|R], Acc) ->
    case check(Prime, P) of
         true -> valid(Prime, R, Acc ++ [P]);
         false -> valid(Prime, R, Acc)
    end.

valid(Prime, Primes) ->
    case ets:lookup(cache, Prime) of
        [] ->
            Valid = valid(Prime, Primes, []),
            ets:insert(cache, {Prime, Valid}),
            Valid;
        [{Prime, Valid}] -> Valid
    end.

find_first() ->
    Primes = util:primes_to(10000),
    ets:new(cache, [set, named_table]),

    try lists:flatmap(
        fun (P1) ->
            P2Valid = euler60:valid(P1, Primes),
            lists:flatmap(
                fun (P2) ->
                    P3Valid = sets:intersection([euler60:valid(P2, Primes), P2Valid]),
                    lists:flatmap(
                        fun(P3) ->
                            P4Valid = sets:intersection([euler60:valid(P3, Primes), P3Valid]),
                            lists:flatmap(
                                fun (P4) ->
                                    P5Valid =  sets:intersection([euler60:valid(P4, Primes), P4Valid]),
                                    lists:map(
                                    fun(P5) ->
                                        io:format("sum ~p = ~p ~n", [{P1,P2,P3,P4,P5}, lists:sum([P1,P2,P3,P4,P5]) ]),
                                        throw({found_one, {P1,P2,P3,P4,P5}}),
                                        {P1,P2,P3,P4,P5}
                                    end,
                                    sets:to_list(P5Valid))
                                end,
                                sets:to_list(P4Valid)
                            )
                        end,
                        sets:to_list(P3Valid)
                    )
                end,
                sets:to_list(P2Valid)
            )
        end,
        Primes)
    catch
        throw:{found_one, {P1,P2,P3,P4,P5}} ->
            {P1,P2,P3,P4,P5}
    end.