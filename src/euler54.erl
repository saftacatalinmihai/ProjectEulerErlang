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
  sort(map( fun ({N, _}) -> N end, Hand)).

max_card(Hand) ->
  hd(lists:reverse(euler54:hand_nums(Hand))).

hand_suites(Hand) ->
  map( fun ({_, S}) -> S end, Hand).

isFlush([{_,S} | RestCards]) ->
  all(fun({_,S1}) -> S =:= S1 end, RestCards).

isStraight(Hand) ->
  Nums = hand_nums(Hand),
  Nums2 = sort(map(
    fun(N) ->
      case N =:= 14 of
        true -> 1;
        false -> N
      end
    end,
    Nums
  )),
  IsStraight = fun ([H|T]) ->
              lists:seq(H, H + length(T)) =:= [H | T]
            end,

  IsStraight(Nums) or IsStraight(Nums2).

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

  HandKind = case groups(Hand) of
    [{4, [{N, _} | _]}, {1, [{N2, _}]}] -> {four_of_a_kind, {N, N2}};
    [{3, [{N, _} | _]}, {2, [{N2,_} | _]}] -> {full_house, {N, N2}};
    [{3, [{N, _} | _]}, {1, [{N2,_}]}, {1, [{N3,_} ]}] -> {three_of_a_kind, {N, N2, N3}};
    [{2, [{N1, _}| _]}, {2, [{N2, _} | _]}, {1, [{N3, _}]}] -> {two_pairs, {N1, N2, N3}};
    [{2, [{N1, _} | _]}, {1, [{N2, _} | _]}, {1, [{N3, _} | _]}, {1, [{N4, _} | _]}] -> {one_pair, {N1, N2, N3, N4}};
                _ -> {nothing, 0}
  end,

  {RoyalFlush, StraightFlush, FourOAK, FullHouse, Flush, Straight, ThreeOAK, TwoPairs, OnePair} =
    { isRoyalFlush(Hand),
      isStraightFlush(Hand),
      element(1, HandKind) =:= four_of_a_kind,
      element(1, HandKind) =:= full_house,
      isFlush(Hand),
      isStraight(Hand),
      element(1, HandKind) =:= three_of_a_kind,
      element(1, HandKind) =:= two_pairs,
      element(1, HandKind) =:= one_pair
      },

  if RoyalFlush ->      [10];
     StraightFlush ->   [9, hand_nums(Hand)];
     FourOAK ->
                        {four_of_a_kind, {NN, NN2}} = HandKind,
                        [8, NN, NN2];
     FullHouse ->
                        {full_house, {NN, NN2}} = HandKind,
                        [7, NN, NN2];
     Flush ->           [6, max_card(Hand)];
     Straight ->        [5, max_card(Hand)];
     ThreeOAK ->
                        {three_of_a_kind, {NN, NN2, NN3}} = HandKind,
                        [4, NN] ++ reverse(sort([NN2, NN3]));
     TwoPairs ->
                        {two_pairs, {NN1, NN2, NN3}} = HandKind,
                        [3] ++ reverse(sort([NN1, NN2])) ++ [NN3];
     OnePair ->
                        {one_pair, {NN1, NN2, NN3, NN4}} = HandKind,
                        [2, NN1] ++ reverse(sort([NN2, NN3, NN4]));

     true ->            [1] ++ reverse(hand_nums(Hand))
  end.

readlines(FileName) ->
  {ok, Device} = file:open(FileName, [read]),
  get_all_lines(Device, []).

get_all_lines(Device, Accum) ->
  case io:get_line(Device, "") of
    eof  -> file:close(Device), Accum;
    Line -> get_all_lines(Device, Accum ++ [line_to_hand_pairs(Line)])
  end.

parse_num(N) ->
  case string:to_integer(N) of
    {error, _} -> parse_high_card(N);
    {Nr, _} -> Nr
  end.

parse_high_card(Hc) ->
  case Hc of
    "T" -> 10;
    "J" -> 11;
    "Q" -> 12;
    "K" -> 13;
    "A" -> 14
  end.

line_to_hand_pairs(Line) ->
  [ C1N, C1S, 32, C2N, C2S, 32, C3N, C3S, 32, C4N, C4S, 32, C5N, C5S, 32,
    C6N, C6S, 32, C7N, C7S, 32, C8N, C8S, 32, C9N, C9S, 32, C10N, C10S | _] = Line,
  Nums =   map(fun parse_num/1, string:tokens([C1N, 32, C2N, 32, C3N, 32, C4N, 32, C5N, 32 , C6N, 32, C7N, 32, C8N, 32, C9N, 32, C10N], " ")),
  Suites = string:tokens([C1S, 32, C2S, 32, C3S, 32, C4S, 32, C5S, 32, C6S, 32, C7S, 32, C8S, 32, C9S, 32, C10S], " "),
  lists:split(5, lists:zip(Nums, Suites)).

euler54() ->
  Hands = euler54:readlines("p054_poker.txt"),
  length(
    lists:filter(
      fun ({H1, H2}) ->
        hand_value(H1) >= hand_value(H2)
      end,
      Hands)).

euler54_test() ->
  ?assertEqual(euler54(), 376).

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

read_line_test() ->
  {H1, H2} = line_to_hand_pairs("5H 5C 6S 7S KD 2C 3S 8S 8D TD\n"),
  ?assertEqual(hand_value(H1) < hand_value(H2), true),

  {H3, H4} = line_to_hand_pairs("5D 8C 9S JS AC 2C 5C 7D 8S QH\n"),
  ?assertEqual(hand_value(H3) > hand_value(H4), true),

  {H5, H6} = line_to_hand_pairs("2D 9C AS AH AC 3D 6D 7D TD QD\n"),
  ?assertEqual(hand_value(H5) < hand_value(H6), true),

  {H7, H8} = line_to_hand_pairs("4D 6S 9H QH QC 3D 6D 7H QD QS\n"),
  ?assertEqual(hand_value(H7) > hand_value(H8), true),

  {H9, H10} = line_to_hand_pairs("2H 2D 4C 4D 4S 3C 3D 3S 9S 9D\n"),
  ?assertEqual(hand_value(H9) > hand_value(H10), true),

  {H11, H12} = line_to_hand_pairs("AH 2D 3C 4D 5S 3C 3D 3S 5S 9D\n"),
  ?assertEqual(hand_value(H11) > hand_value(H12), true).
