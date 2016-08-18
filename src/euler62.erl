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
    [{N,_}|_] = euler62:filter_number_of_cubes(4,euler62:cube_list_perms(euler62:cubes_to(9999))),
    ?assertEqual(N, [1,2,7,0,3,5,9,5,4,6,8,3]).

is_perm(A,B) ->
    lists:sort(A) =:= lists:sort(B).

find_perms(X,L) ->
    {X,find_perms(X,L,[])}.

find_perms(_,[], Acc) -> Acc;
find_perms(X,[H|T], Acc) ->
    case is_perm(X,H) of
        true  -> find_perms(X, T, [H|Acc]);
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
        L  -> cube_list_perms(T, [L | Acc])
    end.

filter_number_of_cubes(N,L) ->
    lists:reverse(lists:filter(
        fun ({_, P}) when length(P) =:= N -> true;
            (_) -> false
        end,
        L
    )).
