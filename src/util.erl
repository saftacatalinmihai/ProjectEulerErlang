%%%-------------------------------------------------------------------
%%% @author casafta
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Jun 2016 11:32
%%%-------------------------------------------------------------------
-module(util).
-author("casafta").
-compile(export_all).
-import(lists, [map/2, foldl/3, filter/2, seq/2, sum/1]).
%% Sum of digits
%% Ex: 123 ->  1 + 2 + 3 = 6
sumDigits(N) -> sumDigits(N, 0).
sumDigits(N, Acc) when N div 10 >= 1 -> sumDigits(N div 10, Acc + N rem 10);
sumDigits(N, Acc) -> N + Acc.

%% Factorial
%% fact(4) -> 1 * 2 * 3 * 4 = 24
fact(N) -> fact(N, 1).
fact(1, Acc) -> Acc;
fact(N, Acc) -> fact(N - 1, N*Acc).

sumOfProperDivs(N) -> sum(properDivs(N)).

isPerfect(N) ->sum(properDivs(N)) =:= N.
isAbundant(N) ->sum(properDivs(N)) > N.
isDeficient(N) ->sum(properDivs(N)) =< N.

abundantList() ->
  filter(fun(X) -> util:isAbundant(X) end,seq(1, 28123)).
properDivs(N) ->
  L = gb_sets:to_list(
    foldl(
      fun(X, Acc) -> gb_sets:add(X, gb_sets:add(N div X, Acc)) end,
      gb_sets:new(),
      filter(
        fun(X) -> N rem X =:= 0 end,
        seq(1, trunc(math:sqrt(N)))))),
  lists:sublist(L, length(L) - 1).