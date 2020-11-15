%%%-------------------------------------------------------------------
%%% @author mo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Oct 2020 2:47
%%%-------------------------------------------------------------------
-module(towerofhanoi).
-author("mo").

%% API
-compile(export_all).

%https://stackoverflow.com/questions/26431725/erlang-towers-of-hanoi


start(N) ->
  Game = #{1 => lists:seq(1,N), 2 => [], 3 => []},
  display(Game, N),
  move()