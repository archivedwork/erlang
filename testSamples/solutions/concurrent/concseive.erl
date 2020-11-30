-module(seive).
-compile([export_all]).

start() ->
    init(5,5).

init(N,W)-> spawn(?MODULE,create_ring,[N, W]).  
	
create_ring(N, W)->
	register(main,self()),
  Pid = lists:foldl(fun(_,Next)->spawn(?MODULE,worker,[Next]) end, main, lists:seq(1,W)), 
  io:format("Ring Pid : ~p ~n",[Pid]),
  Pid ! {check, N,  lists:seq(2,N)},
  worker(Pid),
  rec([]).

worker(NextPid)->
	io:format("Worker process is ~p~n",[self()]),  
	receive
		{check, N, L} -> loop(N, NextPid,L)
	after 10000 -> timeout
	end.

loop(N, NextPid, Result=[H|T]) when  N >= (H * H)->
	Main = whereis(main),
  Res = lists:filter(fun(E)-> E rem H /= 0 end, T),
  io:format("sending ~p to Main ~p ~n",[H,Main]),
  Main ! {next, H}, NextPid ! {check,  N, Res}, 
  worker(NextPid);
loop(N, NextPid, L)-> 	Main = whereis(main), Main ! {ends, L}.


rec(Rec)->
	receive
		{ends,Tail} -> 
    io:format("End worker: ~p ~p ~n", [Rec, Tail]),
    erlang:display(lists:reverse(Rec) ++ Tail);
		{next,Res} ->	
    io:format("Received : ~p ~n", [[Res|Rec]]),
    rec([Res|Rec])
	after 1000 -> timeout
	end.


% kill all processes
kill([]) -> all_processes_are_dead;
kill([P|Pids]) ->
    io:format("process ~p dead ~p ~n", [P, exit(P,dead)]),
    %or 
    % P ! dead,
    kill(Pids).
