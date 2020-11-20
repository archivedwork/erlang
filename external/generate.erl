%%%-------------------------------------------------------------------
%%% @author mo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Nov 2020 23:48
%%%-------------------------------------------------------------------
-module(generate).
-author("mo").

%% API
-compile(export_all).

pmap(Fun) ->
  Pids = lists:map(fun(Elem) -> spawn(?MODULE, apply, [self(), Fun, Elem]) end, lists:seq(1,10)),
  io:format("PIDS= ~p~n", [Pids]),
  lists:map(fun(Pid) ->
    receive
      {Pid, Result} -> Result
    end
            end
    , Pids).




apply(From, Fun, Elem) ->
  From ! {self(), Fun(Elem)}.
