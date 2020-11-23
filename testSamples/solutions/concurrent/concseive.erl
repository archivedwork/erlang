-module(conc_sieve).
-compile([export_all]).

	%% {check, N, [1,2,....N]} 
	%% {next,Result} stores the new result, then loop again  
  %% {ends,Tail}  returns all the previously stored Results, plus Tail and terminates

init(N,W)-> spawn(?MODULE,startring,[N, W]).  
	
startring(N, W)->
	register(main,self()),
  Lpid = lists:foldl(fun(_,Next)->spawn(?MODULE,worker,[Next]) end, main, lists:seq(1,W)), 
  io:format(" start ring PID ~p ~n",[Lpid]),
  Lpid ! {check, N,  lists:seq(2,N)},
  worker(Lpid),
  rec([]),
  io:format("Main is ~p ~n",[self()]).

worker(NextPid)->
	io:format("The worker process is ~p~n",[self()]),  
	receive
		{check, N, L} -> workeraction(N, NextPid,L)
	after 10000 -> something_wrong_worker
	end.

workeraction(N, NextPid, Result=[EH|ET]) when  N >= (EH * EH)->
	Main = whereis(main),
  Res = lists:filter(fun(E)-> E rem EH /= 0 end, ET),
  io:format("sending ~p to Main ~p ~n",[EH,Main]),
  Main ! {next, EH}, NextPid ! {check,  N, Res}, 
  worker(NextPid);
workeraction(N, NextPid, L)-> 	Main = whereis(main), Main ! {ends, L}.


rec(Acc)->
	receive
		{ends,Tail} -> 
    io:format("received the end worker: ~p ~p ~n", [Acc, Tail]),
    erlang:display(lists:reverse(Acc) ++ Tail);
		{next,Res} ->	
    io:format("received : ~p ~n", [[Res|Acc]]),
    rec([Res|Acc])
	after 1000 -> something_wrong_rec
	end.


  %kill process
  
  kill(Pid) ->
    exit(Pid, dead).
