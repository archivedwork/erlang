-module(inn).
-compile(export_all).

% create a node called inn and run the goblins there.
% {inn, inn@localhost}

create_goblins(N) when N >= 10 -> exit;
create_goblins(N) when N < 10 ->
    Spawn = fun(X) ->
        Name = randGoblinNames(6),
        Pid = spawn(inn@localhost, fun() -> receive _A -> goblin() end end),
        io:format("Pid is: ~p~n", [Pid]),
        global:register_name(Name, Pid) end,
        [Spawn(X) || X <- lists:seq(1,N)],
        io:format("registered goblins are ~p~n", [global:registered_names()]).
  


% randGoblinNames(N)  where N is a number for word long
randGoblinNames(N) -> randGoblinNames(N, []).

randGoblinNames(0, Acc) -> Acc;
randGoblinNames(N, Acc) -> randGoblinNames(N - 1, [random:uniform(26) + 96 | Acc]).





% {traveller, traveller@localhost}

%%%%%%%%%%%%%%%% Traveler Implementation %%%%%%%%%%%%%%%%%%%%%%%
traveler() ->
    spawn('traveler@localhost', ?MODULE, inn_adventure, []).




%%%%%%%%%%%%%%%%% Inn Adventure Implementation %%%%%%%%%%%%%%%%
inn_adventure() ->
    global:registered_names(),
    io:format("global registered mygoblin : ~p~n", [global:registered_names()]).

    %GoblinNumbers = (length(Processes) / 2) + 1,
    %io:format("Goblins Numbers: ~p~n", [GoblinNumbers]).

goblin() ->

    Bed = free,
    receive
        {on_bed, TravelerId} ->
            Bed = on_bed;

        {leaving_bed, TravelerId} ->
            Bed = free 
    after 2000 -> timeout
end.




%% backend
handlebed(TravelerId, Bed, DiceRoll) when DiceRoll =< 6 ->
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