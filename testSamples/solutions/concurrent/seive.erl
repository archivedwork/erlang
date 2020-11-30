-module(seive).
-compile(export_all).



start(W) -> 
    spawn(?MODULE, create_ring, [W]).



create_ring(W) ->
    Pids = lists:map(fun(_) -> spawn(?MODULE, worker, []) end, lists:seq(1,W)),
    %io:format("All Processes are: ~p~n", [Pids]),
    sendNext(Pids).


%sendNext([]) -> [];
sendNext(AllPids=[P|APids]) ->
    Self = self(),
    %io:format("current process is: ~p~n", [P]),
    RingProcesses = APids ++ [P],
    io:format("Ring Processes are: ~p~n", [RingProcesses]),
    helper(AllPids, RingProcesses).

helper([], _) -> [];
helper([HP|HPids], [HN|NPids]) ->
    register(nextProcess, HN),
    HP ! {next, HN},   % send
    io:format("current process is: ~p Next is ~p~n", [HP, HN]),
    io:format("Send: ~p to ~p~n", [{next,HN}, HP]),

    receive
        hello ->
            hey_im_receiving_hello
        after 1000 -> ok
    end,
    helper(HPids, NPids).


worker() ->
    NextProcess = whereis(nextProcess),
    worker(NextProcess).

worker(NPid) -> 
    io:format("worker ~p is alive ~n", [self()]),
    NPid ! hello.




kill([P|Pids]) ->
        