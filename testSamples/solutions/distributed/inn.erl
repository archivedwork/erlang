-module(inn).
-compile(export_all).




% create a node called inn and run the goblins there.
% {inn, inn@localhost}

create_goblins(N) when N >= 10 -> exit;
create_goblins(N) when N < 10 ->
     Spawn =  fun(X) ->
                    %Name = randGoblinNames(6),       % or use Xbin and Name below 
                    Xbin = erlang:integer_to_binary(X),
                    Name = erlang:binary_to_atom(<<"im_gobbi_", Xbin/binary>>, utf8),
                    %Pid = spawn(inn@localhost, fun() -> receive _A -> goblin() end end),
                    Pid = spawn(inn@localhost, fun() -> goblin() end),
                    io:format("Pid is: ~p~n", [Pid]),
                    global:register_name(Name, Pid)
                end,
                
        [Spawn(X) || X <- lists:seq(1,N)],

        io:format("registered goblins are ~p~n", [global:registered_names()]).



% randGoblinNames(N)  where N is a number for word long (word length)
randGoblinNames(N) -> randGoblinNames(N, []).

randGoblinNames(0, Acc) -> Acc;
randGoblinNames(N, Acc) -> randGoblinNames(N - 1, Acc ++ [rand:uniform(6) + 96]).




% {traveller, traveller@localhost}

%%%%%%%%%%%%%%%% Traveler Implementation %%%%%%%%%%%%%%%%%%%%%%%
traveler() ->
    Traveller = spawn('traveler@localhost', ?MODULE, inn_adventure, []).





%%%%%%%%%%%%%%%%% Inn Adventure Implementation %%%%%%%%%%%%%%%%
inn_adventure() ->
    
    %GoblinsList = global:registered_names(),
    % GoblinID ==  index of distinct if Distinct = 3 then bring goblin id in index 3 then get the id
    
     %Goblin = lists:nth(DINSTINCT, GoblinsList),
    % GoblinId = global:whereis_name(Goblin),
    % global:register_name(gid, GoblinId), % already registered no need for register again
    % io:format("global registered goblins are ~p~nlength of them are ~p~nDistinct is ~p~nthe Goblin is ~p~nGoblinId is ~p~n", [global:registered_names(), N, DINSTINCT, Goblin, GoblinId]),
    % send allow message to goblin and usse_bed

    % Goblin = lists:nth(DINSTINCT, GoblinsList),
    % GoblinId = global:whereis_name(Goblin),

    % global:send(Goblin, Message).

    GoblinsList = global:registered_names(),
    TravellerId = self(),
    Message =  {use_bed, TravellerId},

    N = length(global:registered_names()),
    DINSTINCT = (N div 2 + 1),

    
   lists:map(
        fun(Name) -> 
        global:send(Name, Message),
        io:format("traveller: Send ~p to Goblin ~p ~n", [Message, Name])
    end, GoblinsList),

   
    receive 
        {grant, TravelerId} -> 
            io:format("inn: received ~p~n", {grant, TravelerId}),
            if DINSTINCT rem 2 == 0 -> 
                global:send(TravelerId, {on_bed, TravelerId}),
                timer:sleep(5000),
                global:send(TravelerId, {leaving_bed, TravelerId});
                
                
                true -> 
                    receive
                    after 3000 -> inn_adventure()
                    end
            end;


        {grunt, TravelerId} -> 
            io:format("inn: received ~p~n", {grunt, TravelerId})
        after 2000 -> timeout
    end.
    
    


goblin() ->
    GoblinsList = global:registered_names(),
    Bed = free,
    receive 
        {use_bed, TravelerId} ->
                io:format("inn: Goblin received ~p~n", [{use_bed, TravelerId}]),
            handlebed(TravelerId, Bed, diceroll(6)),
            goblin()
                % receive
                %    {on_bed, TravelerId} ->
                %            {on_bed, TravelerId};
                %    {leaving_bed, TravelerId} ->
                %            {free, TravelerId} 
                % end
    end.

%net_adm:ping('inn@localhost').


%%%%%%%%%%%%%%%%%%%%%%%%%%% backend %%%%%%%%%%%%%%%%%%%%%%%%

% how to call handlebed/3 from terminal
% > Pid = pid(0,120,0).
% > c(inn).
% > inn:create_goblins(4).
% > inn:handlebed(Pid, on_bed, inn:diceroll(6)).
% {grunt,<0.120.0>}


handlebed(TravelerId, Bed, DiceRoll) when DiceRoll =< 6 ->   % TravelerId here is the inn_adventure function Pid
    case DiceRoll of 
        1 ->
            if Bed == free ->
                io:format("handlebed: sending ~p to goblinId ~p and Bed is ~p~n", [{grunt, TravelerId},TravelerId, Bed]), 
                global:send(TravelerId, {grunt, TravelerId});
                %TravelerId ! {grunt, TravelerId};   % not allowed to pass
                true -> ok% TravelerId ! {grunt, TravelerId} % bed_not_free % handlebed(TravelerId, Bed, diceroll(6))
            end;
        5 ->
            if Bed == free ->
                io:format("handlebed: sending ~p to goblinId ~p and Bed is ~p~n", [{grant, TravelerId},TravelerId, Bed]), 
                TravelerId ! {grant, TravelerId};
            true -> TravelerId ! {grant, TravelerId} 
            end;
        _ ->
            if Bed =/= free ->
                if TravelerId =/= self() ->    % self() here means a different Pid   (Bed is not free but a different Pid)
                    io:format("handlebed: sending ~p to goblinId ~p and Bed is ~p~n", [{grunt, TravelerId},TravelerId, Bed]),
                    TravelerId ! {grunt, TravelerId};
                    true -> is_equal
                end;
            true -> Bed
            end
        end.


% diceroll random number generation
diceroll(N) when N > 6  -> 0; 
diceroll(N) when N =< 6 ->
    rand:uniform(N).







%%%%%%%%%%%%%%%%%%%% Game Over Implementation %%%%%%%%%%%%%%%%%%%%%%%
% kills all goblins and its monitors
sentinel() ->
    GetRegisteredGoblins = global:registered_names(),
    sentinel_helper(GetRegisteredGoblins).


sentinel_helper([]) -> all_monitored_goblins_are_dead;
sentinel_helper([P|Pids]) ->
    MRef = erlang:monitor(process, global:whereis_name(P)),
    io:format("goblin ~p with pid of ~p and Ref of ~p is killed ~p~n", [P, global:whereis_name(P), MRef, exit(global:whereis_name(P), kill)]),
    %erlang:flush(),
    sentinel_helper(Pids).    
    


% kill all the goblins
gameover() ->
    LstOfRegGoblins = global:registered_names(),
    gameOverHelper(LstOfRegGoblins).


gameOverHelper([]) -> all_goblins_are_dead;
gameOverHelper([P|Pids]) ->
    io:format("goblin ~p with pid of ~p is dead ~p~n", [P, global:whereis_name(P), exit(global:whereis_name(P), dead)]),
    gameOverHelper(Pids).









% %%%%%%%%%%%%%%%% inn_adventure1(Patience) psudo code %%%%%%%%%%%
inn_adventure1(0) -> gameover();
inn_adventure1(Patience) ->
    TravelerId = self(),
    receive 
        {use_bed, TravelerId} ->
            inn_adventure1(Patience - 1)
        
        end.






% instructions to execute 
% inn@localhost> net_adm:ping('traveler@localhost').
% inn@localhost> net_adm:ping('traveler1@localhost').
% inn@localhost> c(inn).
% inn@localhost> inn:create_goblins(6).
% inn@localhost>






% traveler@localhost>inn:traveler().



% traveler1@localhost> inn:traveler().