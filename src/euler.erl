%%%-------------------------------------------------------------------
%%% @author casafta
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Jun 2016 11:29
%%%-------------------------------------------------------------------
-module(euler).
-author("casafta").
-import(util, [fact/1, sumDigits/1, isAbundant/1, isDeficient/1, isPerfect/1]).
-compile(export_all).
%% API
%%-export([test/0]).
euler20() ->
  sumDigits(
    fact(100)
  ).

d(N) -> util:sumOfProperDivs(N).

hasAmicable(N) ->
  A = d(N),
  (d(A) =:= N) and (A =/= N).

euler21() ->
  lists:sum([X || X <- lists:seq(1,10000), hasAmicable(X)]).

euler22() ->
  {ok, Data} = file:read_file("../p022_names.txt"),
  NamesBin = binary:split(Data, [<<",">>], [global]),
  lists:map(fun(X) -> binary:bin_to_list(binary:replace(X, <<"\"">>, <<"">>)) end,  NamesBin).


%%euler20_test() ->
%%  648 = euler20(),
%%  ok.
%%
%%euler21_test() ->
%%  31626 = euler21(),
%%  ok.

euler23_test() ->
%%  lists:filter(fun(X) -> util:isAbundant(X) end, lists:seq(1, 28123))
%%  lists:filter(fun(X) -> 100 rem X =:= 0 end, lists:seq(1, trunc(math:sqrt(100))))
  10 = trunc(math:sqrt(100)),
  true = isPerfect(28),
  true = isAbundant(12).