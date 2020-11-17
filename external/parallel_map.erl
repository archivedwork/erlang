%%%-------------------------------------------------------------------
%%% @author mo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Nov 2020 14:46
%%%-------------------------------------------------------------------
-module(parallel_map).
-author("mo").

%% API
-compile(export_all).


pmap(Fun, List) ->
  Pids = lists:map(fun(Elem) -> spawn(?MODULE, apply, [self(), Fun, Elem]) end, List),
  io:format("PIDS= ~p~n", [Pids]),
  lists:map(fun(Pid) ->
    receive
      {Pid, Result} -> Result
    end
  end
  , Pids).




apply(From, Fun, Elem) ->
  From ! {self(), Fun(Elem)}.