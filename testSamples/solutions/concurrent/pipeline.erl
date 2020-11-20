-module(pipeline).

-compile(export_all).


% start create ring of 6 processes
start() ->
    Self = self(),
    Processes = [spawn(fun() -> pipe(Self) end) || _ <- lists:seq(1,6)],
    io:format("six Processes are : ~p~n", [Processes]),
    [H|_] = Processes,
    io:format("ring processes are : ~p~n", [lists:append(Processes, [H])]),
    H ! {forward, 5}.  % send {forward,5} to first process


pipe(Pid) -> 
    io:format("pipe Pid ~p~n", [Pid]),
    receive
        {forward, N} ->
            Pid ! 1; % send N+1 to Next Pid
        
        quit ->
           Pid ! quit
    end.