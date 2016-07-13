%%%-------------------------------------------------------------------
%%% @author mihai
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Jul 2016 11:30 AM
%%%-------------------------------------------------------------------
-module(euler54).
-author("mihai").

-include_lib("eunit/include/eunit.hrl").

%% API
-compile(export_all).
%%-export([]).
-import(lists, [map/2, sort/1, sort/2, all/2, reverse/1]).

hand_nums(Hand) ->
  sort(map( fun ({N, _S}) -> N end, Hand)).

max_card(Hand) ->
  hd(lists:reverse(euler54:hand_nums(Hand))).

hand_suites(Hand) ->
  map( fun ({_N, S}) -> S end, Hand).

isFlush([{_N,S} | RestCards]) ->
  all(fun({_N1,S1}) -> S =:= S1 end, RestCards).

isStraight(Hand) ->
  [First | Rest] = hand_nums(Hand),
  lists:seq(First, First + length(Rest)) =:= [First | Rest].

isStraightFlush(Hand) -> isStraight(Hand) and isFlush(Hand).

isRoyalFlush(Hand) ->
  {N,_} = hd(sort(Hand)),
  isStraightFlush(Hand) and (N =:= 10).

pairs([]) -> [];
pairs([C]) -> [[C]];
pairs([{N,_S} | Rest]) ->
  Hand = [{N,_S} | Rest],
  {G1, G2} = lists:partition(fun({N1,_S1}) -> N1 =:= N end, Hand ),
  sort([G1| pairs(G2)]).

groups(Hand) ->
  reverse(sort(map(fun(P) -> {length(P), P} end, pairs(Hand)))).

hand_value(Hand) ->

  HandValue = case groups(Hand) of
    [{4, [{N, _} | _]}, _] -> {four_of_a_kind, N};
    [{3, [{N, _} | _]}, {2, [{N2,_} | _]}] -> {full_house, {N, N2}};
    [{3, [{N, _} | _]}, {1, [{N2,_}]}, {2, [{N2,_} ]}] -> {three_of_a_kind, {N, N2}};
    [{2, [{N1, _}| _]}, {2, [{N2, _} | _]}, {1, [{N3, _}]}] -> {two_pairs, {N1, N2, N3}};
    [{2, [{N1, _} | _]}, {1, [{N2, _} | _]}, {1, [{N3, _} | _]}, {1, [{N4, _} | _]}] -> {one_pair, {N1, N2, N3, N4}};
                _ -> {nothing, 0}
  end,

  {RoyalFlush, StraightFlush, FourOAK, FullHouse, Flush, Straight, ThreeOAK, TwoPairs, OnePair} =
    { isRoyalFlush(Hand),
      isStraightFlush(Hand),
      element(1, HandValue) =:= four_of_a_kind,
      element(1, HandValue) =:= full_house,
      isFlush(Hand),
      isStraight(Hand),
      element(1, HandValue) =:= three_of_a_kind,
      element(1, HandValue) =:= two_pairs,
      element(1, HandValue) =:= one_pair
      },

  if RoyalFlush ->
        [9];
     StraightFlush ->
       [8, hand_nums(Hand)];
     FourOAK ->
       {four_of_a_kind, NN} = HandValue,
       [7, NN];
     FullHouse ->
       {full_house, {NN, NN2}} = HandValue,
       [6, NN, NN2];
     Flush ->
       [5, max_card(Hand)];
     Straight ->
       [4, max_card(Hand)];
     ThreeOAK ->
       {three_of_a_kind, {NN, NN2}} = HandValue,
       [3, NN, NN2];
     TwoPairs ->
       {two_pairs, {NN1, NN2, NN3}} = HandValue,
       [2] ++ reverse(sort([NN1, NN2])) ++ [NN3];
      OnePair ->
       {one_pair, {NN1, NN2, NN3, NN4}} = HandValue,
       [1, NN1] ++ reverse(sort([NN2, NN3, NN4]));
     true ->
       [0] ++ reverse(hand_nums(Hand))
  end.

readlines(FileName) ->
  {ok, Device} = file:open(FileName, [read]),
  get_all_lines(Device, []).

get_all_lines(Device, Accum) ->
  case io:get_line(Device, "") of
    eof  -> file:close(Device), Accum;
    Line -> get_all_lines(Device, Accum ++ [Line])
  end.

list_to_hands (Line) ->
  [C1N, C1S, 32] = Line.



euler54() ->
  {2, d}.

isFlush_test() ->
    Hand = [{2, d}, {5, d}, {8, d}, {6, d}, {12, d} ],
    ?assertEqual(isFlush(Hand), true),
    Hand2 = [{2, d}, {5, d}, {8, s}, {6, d}, {12, d} ],
    ?assertEqual(isFlush(Hand2), false).

isStraight_test() ->
  Hand = [{2, d}, {3, d}, {4, d}, {5, d}, {6, d} ],
  ?assertEqual(isStraight(Hand), true),
  Hand2 = [{2, d}, {6, d}, {4, d}, {5, d}, {3, d} ],
  ?assertEqual(isStraight(Hand2), true),
  Hand3 = [{2, d}, {6, d}, {8, d}, {5, d}, {3, d} ],
  ?assertEqual(isStraight(Hand3), false).

isStraightFlush_test() ->
  Hand = [{2, d}, {3, d}, {4, d}, {5, d}, {6, d} ],
  ?assertEqual(isStraightFlush(Hand), true),
  Hand2 = [{2, d}, {3, h}, {4, d}, {5, d}, {6, d} ],
  ?assertEqual(isStraightFlush(Hand2), false).

hand_value_test() ->
  H1 = [{5,h}, {5,c}, {6,d}, {7,s}, {13,d}],
  H2 = [{2,c}, {3,s}, {8,s}, {8,d}, {12,d}],
  ?assertEqual(hand_value(H1) < hand_value(H2), true),

  H3 = [{5,d}, {8,c}, {9,s}, {11,s}, {15,c}],
  H4 = [{2,c}, {5,c}, {7,d}, {8,s}, {12,h}],
  ?assertEqual(hand_value(H3) > hand_value(H4), true),

  H5 = [{2,d}, {9,c}, {14,s}, {14,h}, {14,c}],
  H6 = [{3,d}, {6,d}, {7,d}, {11,d}, {13,d}],
  ?assertEqual(hand_value(H5) < hand_value(H6), true),

  H7 = [{4,d}, {6,s}, {9,h}, {12,h}, {12,c}],
  H8 = [{3,d}, {6,d}, {7,h}, {12,d}, {13,s}],
  ?assertEqual(hand_value(H7) > hand_value(H8), true),

  H9 = [{2,d}, {2,d}, {4,c}, {4,d}, {4,s}],
  H10 = [{3,c}, {3,d}, {3,s}, {9,s}, {9,d}],
  ?assertEqual(hand_value(H9) > hand_value(H10), true).