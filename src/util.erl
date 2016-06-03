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

properDivs(N) -> properDivs(N, 2, gb_sets:new()).
properDivs(N, ToTest, Divs) when ToTest >= N div 2 -> [1 |gb_sets:to_list(Divs)];
properDivs(N, ToTest, Divs) when N rem ToTest =:= 0 -> properDivs(N, ToTest + 1, gb_sets:add(ToTest, gb_sets:add(N div ToTest, Divs)));
properDivs(N, ToTest, Divs) -> properDivs(N , ToTest + 1, Divs).

sumOfProperDivs(N) -> lists:sum(properDivs(N)).
