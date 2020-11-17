%%%-------------------------------------------------------------------
%%% @author MO
%%% @copyright (C) 2020, <ELTE>
%%% @doc
%%%
%%% @end
%%% Created : 15. Nov 2020 17:15
%%%-------------------------------------------------------------------
-module(adventure_time).
-author("MO").

%% API
-compile(export_all).


finn(Pid) ->
  io:format("Finn:What time is it?~n"),
  Self = self(),
  Pid ! {what_time_is_it, Self},    % send message to finn pid

  receive
    {adventure_time, Self} ->
      io:format("Finn: That's right buddy~n")
  end.


jake() ->
  receive
      {what_time_is_it, Pid} ->
        io:format("Jake: Adventure time!~n"),
        Pid ! {adventure_time, Pid}
    end.



begin_adventure() ->
  JakePid = spawn(?MODULE, jake, []),
  spawn(?MODULE, finn, [JakePid]).