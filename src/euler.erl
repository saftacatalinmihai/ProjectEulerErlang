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
-import(util, [fact/1, sumDigits/1]).
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

euler20_test() ->
  648 = euler20(),
  ok.

euler21_test() ->
  31626 = euler21(),
  ok.