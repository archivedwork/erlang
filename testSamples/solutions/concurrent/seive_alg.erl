-module(seive_alg).
-compile(export_all).



create_ring(W) ->
    register(main, self()),
    Processes = lists:map(fun(_) -> spawn(?MODULE, worker, []) end, lists:seq(1,W)),
    io:format("Processes are: ~p~n", [Processes]),
    main ! {something, hi}.






worker() ->
    %  receive
    %      {something, Job} ->
            io:format("I worker process ~p ~n", [self()]).
    %end.