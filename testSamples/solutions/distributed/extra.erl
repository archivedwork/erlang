-module(extra).
-compile(export_all).


create_goblins() -> create_goblins(9).

create_goblins(N) ->
    Name = "goblin1", %% list of goblins and then use map
    Pids = spawn(?MODULE, fun() -> goblin(free) end),
    global:register_name(Name, self()).    




traveller() ->
    spawn(?MODULE, inn_adventure, []).



inn_adventure() ->
    TravelerId = self(),
    GList = global:registered_names(),
    % map here 
     global:send(GoblinName, {use_bed, TravelerId}),


     receive 
         {grant, TravelerId} ->
             erlang:flush(),
             global:send(GoblinName, {on_bed,TravelerId}), % use map here or foldl
             Sleep = rand:uniform(5000),
             timer:sleep(5000),
             global:send(GoblinName, {leaving_bed,TravelerId});
            
        {grunt, TravelerId}  -> timer:sleep(3000),% use map here or foldl


            

goblin(Bed) ->
    recevie
        {use_bed, TravelerId} ->
            handle_bed(TravelerId, Bed, rand:uniform(6)),
            receive
                {on_bed,TravelerId} -> on_bed;
                {leaving_bed,TravelerId} -> leaving_bed
            end
    end.



handle_bed(TravelerId, Bed, Dice) ->
    if Dice == 1 ->
        TravelerId ! {grunt, TravelerId}
    if Dice == 5 ->
        TravelerId ! {grant TravelerId}
    _ -> 
        TravelerId ! {grunt, TravelerId}.