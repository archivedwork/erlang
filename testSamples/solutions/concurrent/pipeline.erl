-module(pipeline).

-compile(export_all).


%
start() ->
    create_ring(6).



create_ring(N) ->
    register(main, self()),
    Processes = lists:map(fun(_) -> spawn(?MODULE, pipe, [main])end, lists:seq(1,N)),
    io:format("Processes are: ~p~n", [Processes]),
    sendNext(Processes),
    [HH|_] = Processes,
    pipe(HH),
    %PP = pipe(HH), % HH is next process, apply it to pipe
    %PP ! quit. 
    %timer:sleep(2000),
    kill(Processes).



% know current process and next one
sendNext(AllProcesses=[P|Pids]) ->
    io:format("Current Process is : ~p~n", [P]),
    NextProcess = Pids ++ [P],   % ring created here 
    io:format("Next processes are: ~p~n", [NextProcess]),
    send_next_helper(AllProcesses, NextProcess).


send_next_helper([], _) -> ok;
send_next_helper([HP|HPids], [HNext|NPids]) ->
    HP ! {next, HNext},
    send_next_helper(HPids, NPids).


% pipe worker implementation
pipe(NextPid) ->
    receive
        {forward, N} -> 
            NextPid ! (N+1),  % increase N by 1 (N+1) and send it to Next process
            pipe(NextPid);
        quit ->
            NextPid ! quit

    after 1000 -> timeout_frpm_pipe
    end.



% kill all processes
kill([]) -> all_processes_are_dead;
kill([P|Pids]) ->
        io:format("process ~p dead ~p ~n", [P, exit(P,dead)]),
        kill(Pids).

