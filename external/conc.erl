-module(conc).

-compile(export_all).

% clock
start(Time, Fun) ->
    register(clock, spawn(?MODULE, tick, [])).   % or use spawn(fun() -> tick(Time, Fun) end) or spawn_link() 


stop() ->
    clock ! stop.

tick(Time, Fun) ->
    receive
        stop -> void

    after Time ->
        Fun(),
        tick(Time, Fun)
    end.


% test case
% clock:start(5000, fun() -> io:format("TICK ~p~n", [erlang:now()]) end)


mystart() ->
        %io:format("start receiving messages!~n"),
    %register(testp, spawn(?MODULE, loop, [])).
   %Pid = spawn(?MODULE, loop, []),
   %Pid ! "hi hi".

   Pid = spawn(?MODULE, loop, []),
   register(testp, Pid),
   call("HI").



loop() ->
    receive
        M -> 
            io:format("the Message received is ~p~n", [M])
    end,
    loop().


call(M) ->
    testp ! M.