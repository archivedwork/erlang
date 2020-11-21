-module(spawns).
-compile(export_all).


child() ->
    io:format("I (child) have pid: ~p~n", [self()]),
    receive
    after 1000 ->
        io:format("I (child ~p) will die now!~n ", [self()])
    end.




parent() -> 
    Pid = spawn_link(?MODULE, child, []),   % link child with parent
    %link(Pid),
    io:format("I (parent) have a pid: ~p~n", [self()]),
    io:format("I (parent) ~p have a linked child ~p~n", [self(),Pid]),


    process_flag(trap_exit, false),
    receive
        {'EXIT', Pid, Reason} ->
            timer:sleep(10),
            io:format("I (parent)~p having a dying child(~p). Reason: ~p~n", [self(),Pid, Reason]),
            io:format("I parent will die too...") 
    end.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% spawn monitor

