-module(clientserver).
-compile(export_all).

%%%%%%%%%%%%%%%% Example with one client %%%%%%%%%%%%%%%%%%
% server
server(State) ->
    receive
        {request, Return_PID} ->
            io:format("SERVER ~w: Client request received from ~w~n", [self(), Return_PID]),
            NewState = State + 1,
            Return_PID ! {hit_count, NewState},
            server(NewState) % here server keeps listening
            

        after 2000 -> 'server_die!'
    
    end.




% client
client(Server_Address) ->
    Server_Address ! {request, self()},
    receive
        {hit_count, Number} ->
            io:format("CLIENT ~w: Hit count was ~w~n", [self(), Number])
    end.




start() ->
    Server_PID = spawn(?MODULE, server, [0]),
    spawn(?MODULE, client, [Server_PID]).






