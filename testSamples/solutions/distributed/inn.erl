-module(inn).
-compile(export_all).

% create a node called inn and run the goblins there.
% {inn, inn@localhost}

create_goblins(N) when N >= 10 -> exit;
create_goblins(N) when N < 10 ->
     Spawn =  fun(_X) ->
                    Name = randGoblinNames(6),
                    %Pid = spawn(inn@localhost, fun() -> receive _A -> goblin() end end),
                    Pid = spawn(inn@localhost, fun() -> goblin() end),
                    io:format("Pid is: ~p~n", [Pid]),
                    global:register_name(Name, Pid)
                end,
                
        [Spawn(X) || X <- lists:seq(1,N)],
       % end
        io:format("registered goblins are ~p~n", [global:registered_names()]).
  


% randGoblinNames(N)  where N is a number for word long
randGoblinNames(N) -> randGoblinNames(N, []).

randGoblinNames(0, Acc) -> Acc;
randGoblinNames(N, Acc) -> randGoblinNames(N - 1, [rand:uniform(26) + 96 | Acc]).




% {traveller, traveller@localhost}

%%%%%%%%%%%%%%%% Traveler Implementation %%%%%%%%%%%%%%%%%%%%%%%
traveler() ->
    spawn('traveler@localhost', ?MODULE, inn_adventure, []).





%%%%%%%%%%%%%%%%% Inn Adventure Implementation %%%%%%%%%%%%%%%%
inn_adventure() ->
    L = length(global:registered_names()),
    DINSTINCT = L / 2 + 1,
    % GoblinID =  index of distinct if Distinct = 3 then bring goblin id in index 3
    io:format("global registered goblins are : ~p~n and length of them are ~p~n and Distinct is ~p~n", [global:registered_names(), L, DINSTINCT]).

    %GoblinNumbers = (length(Processes) / 2) + 1,
    %io:format("Goblins Numbers: ~p~n", [GoblinNumbers]).

goblin() ->

    _Bed = free,
    receive
        {on_bed, _TravelerId} ->
            on_bed;

        {leaving_bed, _TravelerId} ->
           free 
    %after 2000 -> timeout
end.




%% backend
handlebed(_TravelerId, Bed, DiceRoll) when DiceRoll =< 6 ->
    case DiceRoll of 
        1 -> 
            if Bed == free ->
                not_allowed_to_pass;
            true -> not_granted
            end;
        5 -> 
            if Bed == free ->
                pass
            end;
        _ ->
            pass
        end.


% diceroll random number generation
diceroll(N) when N > 6  -> 0; 
diceroll(N) when N =< 6 ->
    rand:uniform(N).


%%%%%%%%%%%%%%%%%%%% Game Over Implementation %%%%%%%%%%%%%%%%%%%%%%%
% it only kills all goblins and its monitors
sentinel() ->
    GetRegisteredGoblins = global:registered_names(),
    sentinel_helper(GetRegisteredGoblins).


sentinel_helper([]) -> all_monitored_goblins_are_dead;
sentinel_helper([P|Pids]) ->
    MRef = erlang:monitor(process, global:whereis_name(P)),
    io:format("goblin ~p with pid of ~p and Ref of ~p is killed ~p~n", [P, global:whereis_name(P), MRef, exit(global:whereis_name(P), kill)]),
    %erlang:flush(),
    sentinel_helper(Pids).    
    



gameover() ->
    LstOfRegGoblins = global:registered_names(),
    gameOverHelper(LstOfRegGoblins).


gameOverHelper([]) -> all_goblins_are_dead;
gameOverHelper([P|Pids]) ->
    io:format("goblin ~p with pid of ~p is dead ~p~n", [P, global:whereis_name(P), exit(global:whereis_name(P), dead)]),
    gameOverHelper(Pids).

