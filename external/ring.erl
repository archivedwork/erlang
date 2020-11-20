%%%-------------------------------------------------------------------
%%% @author mo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Nov 2020 19:05
%%%-------------------------------------------------------------------
-module(ring).
-author("mo").

%% API
-compile(export_all).

% create ring of N processes and send M messages between them
message(N,M) ->
  Ring = create_ring(N),
  [Start | T] = Ring,
  Start ! {T, Ring, 1, M}.


create_ring(N) ->
  Processes = [spawn(fun() -> loop() end) || _ <- lists:seq(1,N)],
  io:format("Processes are: ~p~n~n", [Processes]),
  [H|_] =  Processes,
  X = lists:append(Processes, [H]),
  io:format("appending ~p~n", [X]).


loop() ->
  receive
    {[H|T], _L, CurrentMessage, M} ->
      io:format("~p received ~p~n", [self(), CurrentMessage]),
      H ! {T, _L, CurrentMessage, M},
      loop();

    {[], Ring, CurrentMessage, M} ->
      io:format("~p received ~p with empty list ~n", [self(), CurrentMessage]),
      case CurrentMessage < M of
        true ->
          [_ | [Next|T]] = Ring,
          NewMessage = CurrentMessage + 1,
          io:format("Sending message ~p to ~p~n", [NewMessage, Next]),
          Next ! {T, Ring, NewMessage, M};

        false ->
          io:format("Done Sending ~p messages in ~p ring, taking rest now~n", [M, Ring])
      end,
  loop()
  end.





create_ring2(W) ->
  Processes = [spawn(fun() -> ringNode() end) || _ <- lists:seq(1,W)],
  io:format("Pids are ~p~n", [Processes]),
  [H|_] = Processes,
  lists:append(Processes, [H]).



ringNode() ->
  io:format("received process is ~p~n", [self()]),
 
 
 
 
 
 
 
 
  Pid = self(),
  receive
    {neighbor, Pid} ->
      io:format("neighbor pid is ~p~n", [Pid]),
      ringNode()
    end.
