-module(extra).
-compile(export_all).


create_goblins() -> create_goblins(9). % fixed  number of goblins which is 10

create_goblins(N) ->

    NameList = "Gob" ++ lists:seq(1,N),
    NN = list_to_atom("stuu"), % list_to_atom    %% list of goblins and then use map
io:format("gbnames ~p~n", [NN]),    % Pids = spawn(?MODULE, fun() -> goblin(free) end),
    lists:map(fun(Name) -> global:register_name(Name, NameList)end).




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