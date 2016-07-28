%%%-------------------------------------------------------------------
%%% @author mihai
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Jul 2016 3:51 PM
%%%-------------------------------------------------------------------
-module(euler59).
-author("mihai").

-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

euler59_test() ->
  C = get_cipher(),
  [Found | _] = euler59:filter_english(euler59:try_all_keys(C)),
  107359 = lists:sum(Found).

all_ascii() ->
  io:format("~p~n", [only_ascii_chars(try_all_keys(get_cipher()))]).

read_cipher() ->
  {ok, Io} = file:open("p059_cipher.txt", [read]),
  {ok, Str} = file:read_line(Io),
  Str.

parse_cipher([C, $, | Rest]) ->
  [list_to_integer([C]) | parse_cipher(Rest)];

parse_cipher([C1, C2, $, | Rest]) ->
  [list_to_integer([C1,C2]) | parse_cipher(Rest)];

parse_cipher([C1, C2, $\n]) ->
  [list_to_integer([C1,C2])].

get_cipher() -> parse_cipher(read_cipher()).

decode(_, []) -> [];
decode([K,E,Y], [C|R]) -> [ C bxor K | decode([E,Y,K], R)].

try_all_keys(Cipher) ->
  Keys = [[A,B,C] || A <- lists:seq($a,$z), B <- lists:seq($a,$z), C <- lists:seq($a,$z) ],
  lists:map(fun(K) -> decode(K, Cipher) end, Keys).

only_ascii_chars(Decoded) ->
  lists:filter(
    fun(L) ->
      lists:all(
        fun(C) -> (C >= $ ) and ($~ >= C) end, L
      )
    end,
    Decoded
  ).

filter_english(Decoded) ->
  lists:filter(
    fun(L) -> contain_word("the", L) end,
    Decoded
  ).

contain_word(Word, Str) ->
  lists:member(Word, string:tokens(Str, " ")).

