%%%-------------------------------------------------------------------
%%% @author mo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Nov 2020 20:11
%%%-------------------------------------------------------------------
-module(prac).
-author("mo").

%% API
-compile(export_all).



% telephone call

call() ->
  receive
    hello ->
      caller ! hi,
      call();
    goodbye ->
      caller ! ok;
    _ ->
      caller ! 'what:'
  end.



phone() ->
  register(caller, self()),
  start_call().


start_call() ->
  RPid = spawn(fun() -> restartcall() end),
  io:format("RPid = ~p~n", [RPid]),
  receive
    {call, Pid} ->
      {RPid, Pid}
  end.


restartcall() ->
  process_flag(trap_exit, true),
  Pid = spawn_link(?MODULE, call, []),
  caller ! {call, Pid},
  receive
    {'EXIT', Pid, Reason} ->
      io:format("our call was hung up because of ~p~n", [Reason]),
      restartcall();

    quit ->
      dead
  end.


