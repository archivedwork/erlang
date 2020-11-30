-module(inn).
-compile(export_all).

% create a node called inn and run the goblins there.
% {inn, inn@localhost}

create_goblins(N) when N < 10 ->
    global:register_name(create_goblin, spawn(fun() -> goblin() end)).
    %P = whereis(create_goblin),
    %io:format("goblins Pids are ~p~n", [P]).



traveler() ->
    ok.

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
handlebed(TravelerId, Bed, DiceRoll) ->
    ok.