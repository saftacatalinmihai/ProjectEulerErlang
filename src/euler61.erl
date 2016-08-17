%%%-------------------------------------------------------------------
%%% @author mihai
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jul 2016 11:07 AM
%%%-------------------------------------------------------------------
-module(euler61).
-author("mihai").

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

test() ->
     ?assertEqual(28684, lists:sum(find())).

mark(List, Type) ->
    lists:map(
        fun(X) -> {X, Type} end,
        List
    ).

merge_same_num(L) ->
    lists:reverse(
        lists:foldl(
            fun(
                {X, [TypeX]},
                [{N,[TypeHead|TypeRest]}|T]
                ) ->
                case X =:= N of
                    true -> [{N, [TypeX,TypeHead|TypeRest]} | T];
                    false -> [{X, [TypeX]} | [{N,[TypeHead|TypeRest]}|T]]
                end
            end,
            [hd(L)],
            tl(L)
        )
    ).

last2digs(X)  -> X rem 100.
first2digs(X) -> trunc(X / 100).

next_possible_in_chain(N, T, L) ->
    {
        lists:filter(
            fun({X, TypesX}) ->
                case lists:member(T, TypesX) of
                    true  -> false;
                    false -> first2digs(X) =:= last2digs(N)
                end
            end,
            L
        ),
        lists:flatmap(
            fun ({X, _}) when X =:=N -> [];
                ({X, TypesX}) ->
                    case lists:member(T, TypesX) of
                        false -> [{X, TypesX}];
                        true  ->
                            case length(TypesX) =:= 1 of
                                true -> [];
                                false -> [{X, lists:delete(T, TypesX)}]
                            end
                    end
            end,
            L
        )
    }.

next_chain({N, Types},L) ->
    lists:map(
        fun(T) ->
            next_possible_in_chain(N,T,L)
        end,
        Types
    ).

concat_all_poly_types() ->
    Triangles  = mark((util:polynomial_generator(fun(N) -> N*(N+1)/2   end))(1010, 9999), [triangle]),
    Squares    = mark((util:polynomial_generator(fun(N) -> N*N         end))(1010, 9999), [square]),
    Pentagonal = mark((util:polynomial_generator(fun(N) -> N*(3*N-1)/2 end))(1010, 9999), [pentagonal]),
    Hexagonal  = mark((util:polynomial_generator(fun(N) -> N*(2*N-1)   end))(1010, 9999), [hexagonal]),
    Heptagonal = mark((util:polynomial_generator(fun(N) -> N*(5*N-3)/2 end))(1010, 9999), [heptagonal]),
    Octagonal  = mark((util:polynomial_generator(fun(N) -> N*(3*N-2)   end))(1010, 9999), [octagonal]),

    merge_same_num(
        ordsets:union([
            Triangles,
            Squares,
            Pentagonal,
            Hexagonal,
            Heptagonal,
            Octagonal
        ])
    ).

find() ->
    L = concat_all_poly_types(),
    [{{N1,_}, {N2,_},{N3, _}, {N4,_}, {N5,_}, {N6,_}}|_] =
    lists:flatmap(
        fun(N) ->
            N1List = next_chain(N,L),     %% for each type -> { [next terms], [rest] }
            lists:flatmap(
                fun ({NextTerms, RestList}) ->
                    lists:flatmap(
                        fun(NT) ->
                            N2List = next_chain(NT, RestList),
                            lists:flatmap(
                                fun ({NextTerms2, RestList2}) ->
                                    lists:flatmap(
                                        fun(NT2) ->
                                            N3List = next_chain(NT2, RestList2),
                                            lists:flatmap(
                                                fun ({NextTerms3, RestList3}) ->
                                                    lists:flatmap(
                                                        fun(NT3) ->
                                                            N4List = next_chain(NT3, RestList3),
                                                            lists:flatmap(
                                                                fun ({NextTerms4, RestList4}) ->
                                                                    lists:flatmap(
                                                                        fun(NT4) ->
                                                                            N5List = next_chain(NT4, RestList4),
                                                                            lists:flatmap(
                                                                                fun ({NextTerms5, _}) ->
                                                                                    lists:flatmap(
                                                                                        fun({NT5, Types5}) ->
                                                                                            {N0, _} = N,
                                                                                            case last2digs(NT5) =:= first2digs(N0) of
                                                                                                true  -> [{N, NT, NT2, NT3, NT4, {NT5, Types5}}];
                                                                                                false -> []
                                                                                             end
                                                                                        end,
                                                                                        NextTerms5
                                                                                    )
                                                                                end,
                                                                                N5List
                                                                            )
                                                                        end,
                                                                        NextTerms4
                                                                    )
                                                                end,
                                                                N4List
                                                            )
                                                        end,
                                                        NextTerms3
                                                    )
                                                end,
                                                N3List
                                            )
                                        end,
                                        NextTerms2
                                    )
                                end,
                                N2List
                            )
                        end,
                        NextTerms
                    )
                end,
                N1List
            )
        end,
        L
    ),
    [N1,N2,N3,N4,N5,N6].
