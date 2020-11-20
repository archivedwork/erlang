%%%-------------------------------------------------------------------
%%% @author mo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Nov 2020 19:56
%%%-------------------------------------------------------------------
-module(ring3).
-author("mo").

%% API
-compile(export_all).

start() ->
  Self = self(),
  Pid = spawn(?MODULE, loop, []),
  Pid ! {hello, Self}.


loop() ->
  receive
    {Msg, Pid} ->
      ok
  end.