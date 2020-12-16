%% <Mohammed Jamal Hadi>

%% <TBRUEJ>

%% <DDS, Mandatory Assignment>

%% <16.12.2020.>

%% This solution was submitted and prepared by <Mohammed Jamal Hadi, TBRUEJ> for the Distributed Mandatory Assignment.

%% I declare that this solution is my own work.

%% I have not copied or used third party solutions.

%% I have not passed my solution to my classmates, neither  made it public.

%% Students’ regulation of Eötvös Loránd University (ELTE Regulations Vol. II. 74/C. § ) states that as long as a student presents another student’s work - or at least the significant part of it - as his/her own performance, it will count as a disciplinary fault. The most serious consequence of a disciplinary fault can be dismissal of the student from the University.


-module(inn).
-compile(export_all).


%%%%%%%%%%%%%%% inn@localhost node %%%%%%%%%
create_goblins() -> create_goblins_helper(3). % change 0<N<10

create_goblins_helper(N) when N >= 10 -> exit;
create_goblins_helper(N) when N < 10 ->
     Spawn =  fun(X) ->
                    %Name = generateGoblinNames(6),       % or use Xbin and Name below 
                    Xbin = erlang:integer_to_binary(X),
                    Name = erlang:binary_to_atom(<<"gobi_", Xbin/binary>>, utf8),
                    Pid = spawn(inn@localhost, fun() -> receive _A -> goblin(free) end end),
                    %Pid = spawn(inn@localhost, fun() -> goblin(free) end),
                    io:format("Pid is: ~p~n", [Pid]),
                    global:register_name(Name, Pid)
                end,
        [Spawn(X) || X <- lists:seq(1,N)],
        io:format("registered goblins are ~p~n", [global:registered_names()]).


% generateGoblinNames(N)  where N is a number for word long (word length)
generateGoblinNames(N) -> generateGoblinNames(N, []).

generateGoblinNames(0, Acc) -> Acc;
generateGoblinNames(N, Acc) -> 
    generateGoblinNames(N - 1, Acc ++ [rand:uniform(6) + 96]).




%%%%%%%%%%%%%%%% Traveler Implementation %%%%%%%%%%%%%%%%%%%%%%%
%%%Modify the traveler so that after sleeping he will travel (wait for 3 seconds) and then he will start again his inn_adventure (make traveler/1 recursive) .

%traveler(0)  -> timeout;
traveler() ->
        %timer:sleep(Time),
        %spawn('traveler@localhost', ?MODULE, inn_adventure, []),
        spawn(?MODULE, inn_adventure, []).
       % traveler(Time-1).


% net_adm:ping('traveler@localhost').
%%%%%%%%%%%%%%%%% Inn Adventure Implementation %%%%%%%%%%%%%%%%
inn_adventure() ->
    GoblinsList = global:registered_names(),
    TravellerId = self(),
    Message =  {use_bed, TravellerId},

    N = length(global:registered_names()),
    DINSTINCT = (N div 2 + 1),

    
   lists:map(
        fun(Name) -> global:send(Name, Message),
        io:format("traveller: Send ~p to Goblin ~p ~n", [Message, Name]) end, GoblinsList),

   
    receive 
        {grant, TravelerId} -> 
            io:format("traveler: received ~p~n", [{grant, TravelerId}]),
             if DINSTINCT rem 2 == 0 -> 
                %erlang:flush(),
                lists:map(fun(Name) -> global:send(Name, {on_bed, TravelerId}) end, GoblinsList),
                timer:sleep(5000),
                lists:map(fun(Name) -> global:send(Name, {leaving_bed, TravelerId}) end, GoblinsList),inn_adventure();


                                
                 true -> 
                     io:format("wait 3 seconds and try again~n"),
                     timer:sleep(3000)
            end;


        {grunt, _TravelerId} -> 
            io:format("traveler: grunt received~n"),
            inn_adventure()

       % after 2000 -> timeout
    end,
    io:format("~n--------------------------------------------------~n").
    

goblin(on_bed) -> stop;
goblin(Bed) ->
    receive 
        stop -> io:format("terminated!");
        {use_bed, TravelerId} ->
            io:format("Goblin: received ~p~n", [{use_bed, TravelerId}]),
            handlebed(TravelerId, Bed, diceroll(6)),
                receive
                   {on_bed, TravelerId} ->
                       io:format("on_bed received~p ~n", [{on_bed, TravelerId}]),
                            TravelerId ! {on_bed, TravelerId},goblin(Bed);
                   {leaving_bed, TravelerId} ->
                        io:format("leaving received~p ~n", [{leaving_bed, TravelerId}]),
                        TravelerId ! {leaving_bed, TravelerId}, goblin(Bed)
                end,
             goblin(Bed)
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%% backend %%%%%%%%%%%%%%%%%%%%%%%%

% how to call handlebed/3 from terminal
% > Pid = pid(0,120,0).
% > c(inn).
% > inn:create_goblins(4).
% > inn:handlebed(Pid, on_bed, inn:diceroll(6)).
% {grunt,<0.120.0>}

handlebed(TravelerId, Bed, DiceRoll) when DiceRoll =< 6 ->   % TravelerId here is the inn_adventure function Pid
    case Bed == free of
        true ->
            case DiceRoll of 
                1 ->
                    %global:send(TravelerId, {grunt, TravelerId});
                    io:format("handlebed: sending grunt with Diceroll ~p~n",[DiceRoll]),
                    TravelerId ! {grunt, TravelerId}; % 1 == not allowed to pass
                5 ->
                    %global:send(TravelerId, {grunt, TravelerId});
                    io:format("handlebed: sending grant with Diceroll ~p~n",[DiceRoll]),
                    TravelerId ! {grant, TravelerId}; % 5 == allowed to pass
                _ -> 
                    %global:send(TravelerId, {grunt, TravelerId})
                    TravelerId ! {grunt, TravelerId}  % any number == not allowed to pass
                ,io:format("handlebed: sending grunt with Diceroll ~p~n",[DiceRoll])
                end;
                %handlebed(TravelerId, Bed, DiceRoll);
        false ->
            %global:send(TravelerId, {grunt, TravelerId}),
            TravelerId ! {grunt, TravelerId},
            handlebed(TravelerId, Bed, DiceRoll)
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
