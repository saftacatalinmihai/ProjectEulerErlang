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

%% API
%%-export([get_cipher/0, decode/2]).

-compile(export_all).

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
  Keys = [[A,B,C] || A <- lists:seq(97,122), B <- lists:seq(97,122), C <- lists:seq(97,122) ],
  lists:map(fun(K) -> decode(K, Cipher) end, Keys).

only_ascii_chars(Decoded) ->
  lists:filter(
    fun(L) ->
      lists:all(
        fun(C) -> (C >= 32) and (126 >= C) end, L
      )
    end,
    Decoded
  ).