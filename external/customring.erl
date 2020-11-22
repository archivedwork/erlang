-module(customring).
-compile(export_all).


start() ->
    create_ring(5).


create_ring(W) ->
    register(main, self()),        %register main=self() in processes 

    %Processes = [spawn(?MODULE, worker, []) || _ <- lists:seq(1,W)],
    % or
    Processes  = lists:map(fun(_) -> spawn(?MODULE, worker, []) end, lists:seq(1,W)),
    io:format("Processes are: ~p~n", [Processes]),
    sendNext(Processes).


    % Self= self(),
    % ProcessesMonitor = lists:foldl(fun() -> spawn_monitor(?MODULE, worker, []) end,Self, lists:seq(1,4)),
    % io:format("Processes with monitor~p~n", [ProcessesMonitor]).
    %kill(Processes).



% sending to next process
% pid 1 2 3     2 3 1        chain pids
sendNext(AllProcesses=[P|Pids]) ->
    io:format("Current process is: ~p~n", [P]),
    NextProcess = Pids ++ [P],
    %[HH|_] = NextProcess,
    io:format("Next processes are ~p~n", [NextProcess]),
    helper(AllProcesses, NextProcess).


helper([], _) -> empty_helper;
helper([HP|HPids], [HNext|NPids]) ->
    HP ! {next, HNext},
    helper(HPids, NPids).






worker() ->
    receive
        {workthis, Job} -> worker(Job)
    after 2000 -> hey_something_went_wrong
    end.


worker(Fun) ->
    receive
        quit                        -> ok;
        {workthis, Job}             -> worker(Job);
        {compute, Element, Pid}     -> 
            Result = Fun(Element),
            Pid ! Result,
            main ! Result
        %worker(Fun)   % means save previous value / Pid 
    
    after 2000 -> hey_something_went_wrong
    end.



% kill all processes
kill([]) -> all_processes_are_dead;
kill([P|Pids]) ->
    io:format("process ~p dead ~p ~n", [P, exit(P,dead)]),
    %or 
    % P ! dead,
    kill(Pids).





reset() ->
    process_flag(trap_exit, true),  % set trap_exit to true to receive messages with Reason 
    Pid = spawn_link(?MODULE, worker,[]),    % link worker with every reset/restart
    main ! {workthis,Pid},    % send {workthis, Pid} with linked Pid to main rigestered process
    receive
        {'DOWN', Pid, Reason} ->
            io:format("the worker ~p stopped because of ~p~n", [Pid,Reason]),
            reset();
        quit -> dead
    end.





receiver(Results) ->
    receive
        {res, Res} -> receiver([Res|Results]);
        {'DOWN', Ref, }
    
    after 2000 -> timeout

    end.

