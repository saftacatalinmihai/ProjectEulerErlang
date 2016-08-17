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

init() ->
    ets:new(perms, [set, named_table]).

test() ->
     ?assertEqual(1, 1).

is_perm(A,B) ->
    A_perms =   case ets:lookup(perms, A) of
                    [] ->
                        A_p = util:perms(A),
                        ets:insert(perms, {A, A_p}),
                        A_p;
                    [{A, A_p}] -> A_p
                end,

    lists:member(
        B,
        A_perms
    ) and (length(B) =:= length(A)).

find_perms(X,L) ->
%    io:format("Finding ~p in ~p ~n", [X,L]),
    Found = find_perms(X,L,[]),
%    io:format("Found: ~p~n", [Found]),
    {X,Found}.


find_perms(_,[], Acc) -> Acc;
find_perms(X,[H|T], Acc) ->
    case is_perm(H,X) of
        true -> find_perms(X, T, [H|Acc]);
        false -> find_perms(X, T, Acc)
    end.

cubes_to(Max) ->
    lists:map(
        fun util:digits/1,
        [N*N*N || N <- lists:seq(1, Max) ]
    ).

cube_list_perms(L) ->
    lists:filter(
        fun ({_,[]}) -> false;
            (_)      -> true
        end,
        cube_list_perms(L, [])
    ).


cube_list_perms([], Acc) -> Acc;
cube_list_perms([H|T], Acc) ->
    case find_perms(H,T) of
        [] -> cube_list_perms(T, Acc);
        L  -> cube_list_perms(T, [L| Acc])
    end.