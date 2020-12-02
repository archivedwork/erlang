-module(inn).
-compile(export_all).

% create a node called inn and run the goblins there.
% {inn, inn@localhost}

create_goblins(N) when N < 10 ->
    GB = spawn('inn@localhost',?MODULE, goblin, []),
    global:register_name(mygoblin, GB),
    global:whereis_name(mygoblin).
    %[P|Processes]  = lists:map(fun(_) -> spawn(?MODULE, goblin, []) end, lists:seq(1,N)),
    %global:register_name(mygoblin, self()),
    
    %io:format("goblins Pids are ~p~n", [[P|Processes]]).


% {traveller, traveller@localhost}

%%%%%%%%%%%%%%%% Traveler Implementation %%%%%%%%%%%%%%%%%%%%%%%
traveler() ->
    spawn('traveler@localhost', ?MODULE, inn_adventure, []).




%%%%%%%%%%%%%%%%% Inn Adventure Implementation %%%%%%%%%%%%%%%%
inn_adventure() ->
    global:registered_names(),
    io:format("global registered mygoblin : ~p~n", [global:whereis_name(mygoblin)]).

    %GoblinNumbers = (length(Processes) / 2) + 1,
    %io:format("Goblins Numbers: ~p~n", [GoblinNumbers]).

% If he get a request to pass he will decide whether to let the traveler go (handlebed/3 ).

% When a goblin sees a traveler getting on the bed ({on_bed,TravelerId})
% it will refresh is knowledge of Bed with the TravelId.

% When a goblin sees the traveler leaving ({leaving_bed,TravelerId}) 
% and the traveler is the one that was in the Bed,  he will now consider the Bed again free.
goblin() ->

% Each Goblins sees the Bed (initialize them with the atom Bed= free),
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


diceroll(N) when N > 6  -> 0; 
diceroll(N) when N =< 6 ->
    rand:uniform(N).