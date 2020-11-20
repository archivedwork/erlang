%%%-------------------------------------------------------------------
%%% @author mo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Nov 2020 19:34
%%%-------------------------------------------------------------------
-module(ring2).
-author("mo").

%% API
-compile(export_all).

start() ->
  Send = fun({[NextNode|Nodes], Msg}) ->
    NextNode ! {Nodes ++ [NextNode], Msg} end,
  Loop = fun(Loop) ->
    receive
      {Ring, Msg} ->
        io:format("~p ~p~n", [self(), Msg]),
        timer:sleep(200),
        Send({Ring, Msg})
    end,
         Loop()
end,

Ring = [spawn(Loop) || _<- lists:seq(1,3)],
  Send({Ring, "Hello there!"}).