

-module(concurrentTest).
-compile(export_all).



% Keys == [1,2,3,4,5,6,7,8] or "abcde"
start(Keys) -> 
  %Node = whereis(nodepid), %not good no need for this, but from where I will bring the Predecessor for treeNode, ok i got it, it is current process
  Self = self(),
  spawn(?MODULE, treeNode, [Self, Keys]).



 % For now the function just prints  the node pid and his P  L R and Key .
node(Predecessor, Left, Right, Keys, Store) ->
  Self = self(),
  %register(nodepid, self()), % no need ok
  % I am <0.144.0> and point to <0.145.0> an <0.146.0> key is c 
  %io:format("Predecessor: ~p, Left: ~p, Right: ~p, Keys: ~p , nodePid: ~p~n",[Predecessor, Left, Right, Keys,Self]). or this output
  io:format("I am ~p and point to ~p and ~p key is ~p~n", [Predecessor, Left, Right, Keys]).

  %If the node has no left or rigth or previous, you can substitute that Pid with an atom none
  % io:format("I am ~p and point to none key is ~p~n", [Predecessor, _Left, _Right, Keys]).


  %KILL ALL
 % node_kill(Predecessor, Left, Right, Keys).


% Keys is a list
%1- If there are at least 3 keys: it splits the list in half : LeftKeys and RightKeys, takes the first element in RightKeys as its own key K. 
%2- It spawns its' childrens as an other "left side" treeNode/2  with the LeftKeys and a "rigth side" passing to it the RigthKeys.  
%Saving the two Pids as Left and Rigth

treeNode(P, Keys) ->
  Len = length(Keys),
  Predecessor = self(),
  %io:format("length of Keys= ~p~n", [Len]),
  case Len >= 3 of  
    true ->
      {L1,L2} = lists:split(2, Keys),
     % io:format("splitted Keys: ~p~n", [{L1,L2}]),

      %takes the first element in RightKeys as its own key K.
      K = hd(L1), 
     % io:format("K= ~p~n", [K]),
      
       %what are the childrens of the treenode % you spawn two new processes running treeNode(P, Keys), one with left one with right key values okay so the childersns here is the l1  and l2 okay thankk you
      %% they are the new Keys for the two spawn while the P will now be this process PID

      % 3
      L11 = tl(L1),
      Left   = spawn(?MODULE, treeNode, [Predecessor, L11]),  %remove hd of L1 from here tho  ok
      Right  = spawn(?MODULE, treeNode, [Predecessor, L2]),

      %4- If the Keys are only 2: treeNode takes the biggest for itself and only spawns a left side node.
      if length(Keys) == 2 -> spawn(?MODULE, treeNode, [Predecessor, Left]);   %% needs to spawn here like you did above just only for left
      %5- If the Keys are only 1: no further spawning is done and the process takes it as its K
      true -> K    
      end,
    
      %3- calls node/5 passing to it the  3 Pids it knows Predecessor, Left and Rigth, the key K and an empty list for future storage.
      % Predecessor here is self()  line 50
      node(Predecessor, Left, Right, K, []);

    false -> 
      io:format("Length less than 3~n")
      % i can call node here in case of less than 3
  end.






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% KILL ALL %%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% kill single process
kill2(P) -> 
  exit(P, die).


%kill all processes
kill([]) -> [];
kill([P|Pids]) ->
  io:format("process ~p dead ~p ~n", [P, exit(P,dead)]),
  kill(Pids).



%kill all processes 
% We want to make sure that if one node fails, all nodes destroy themselves. Modify node/5 so that:
%1-When their left node dies, node dies as well printing it's Pid and :  "my Left side has died, life has no meaning "
%2-When their right node dies, node dies as well printing it's Pid and :  "my Right side has died, life has no meaning "
%3-When  Predecessor/parent node dies, node dies as well printing it's Pid and :  "my Parent side has died, life has no meaning " 



% I will create a seperate node_kill function


node_kill(Pre, Left, Right, Keys, Store) -> 
  process_flag(trap_exit, true),  % set trap_exit to true to receive messages with Reason 
    LeftPid = spawn_link(?MODULE, treeNode,[Pre, Keys]),   %link treeNode with node_kill through Left
    LeftPid ! {die},

    RightPid = spawn_link(?MODULE, treeNode, [Pre, Keys]),
    RightPid ! {die},


    receive
        {'EXIT', LeftPid, Reason} ->
            io:format("my Left side has died, life has no meaning ~p~n", [LeftPid,Reason]);
        
        {'EXIT', Right, Reason} ->
            io:format("my Right side has died, life has no meaning  ~p~n", [RightPid,Reason]);
          
        quit -> dead
    end.




