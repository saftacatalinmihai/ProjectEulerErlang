%%%-------------------------------------------------------------------
%%% @author mihai
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jul 2016 11:07 AM
%%%-------------------------------------------------------------------
-module(euler62).
-author("mihai").

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

test() ->
    [N|_] = find(10000, 5),
    ?assertEqual(N, [1,2,7,0,3,5,9,5,4,6,8,3]).

find(Max, NumPerms) ->
    L = lists:map(
        fun(L) -> {L,lists:sort(L)} end,
        [util:digits(N*N*N) || N <- lists:seq(1, Max)]
    ),

    [ N ||
        {N,NSorted} <- L,
        length(
            lists:filter(
                fun ({_,XSorted}) -> XSorted =:= NSorted end,
                L
            )
        ) =:= NumPerms
    ].