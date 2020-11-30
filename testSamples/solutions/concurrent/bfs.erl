-module(bfs).
-compile(export_all).
%cd("C:/Users/eannrea/OneDrive - Ericsson AB/Erla/Parallel Tests").

%% construct a balanced binary search three of processes: 
%  Each node is spawned nowing his predecessor an orered list of keys
% the keys are distributed as follows: take the middle key for the current node, 
%  it spawns his left and right branch.
%% 
%% passing the smaller keys to the left 
%% and passing the bigger keys to the right 
%% you should generate as many processes as are the keys, so be careful in case the list is empty or
%% has not enoug nodes to divide among parent and childs

%% the result should be a three were the left branches always hold a smaller value than the current  
%%while the rigth have bigger ones
  
%				         <0.53.0>(5)
%			            /    	    \						
%			  <0.54.0>(3)            <0.55.0>(7)
%			  /        \                /      \	
%	 <0.56.0>(2)   <0.57.0>(4)   <0.58.0>(6)  <0.59.0>(8)
%		 /		
%   <0.60.0>(1)

%%Grade 2-3 (without link)

init(Keys)-> register(main,spawn(?MODULE,start,[Keys])).

trap(true)->ok;
trap(false)->trap(process_flag(trap_exit,true)).

start(Keys)-> 
    trap(false),
	%io:format("Keys:~p~n ",[Keys]),
	Root=spawn_link(fun() -> snode(self(),Keys) end),
	givekeys(Keys).


givekeys(Keys)->
	receive
	{gimmekeys,Pid} -> Pid!{main,Keys}, givekeys(Keys) 
    end.


snode(Prec,[Mine])->
		%io:format("Creating:~c~n ",[Mine]),
		node(Prec,none,none,Mine,[]);

snode(Prec,[Mine,Left]) when Mine>Left->   
  
	L=spawn_link(?MODULE,snode,[self(),[Left]]),
	%io:format("Creating:~c~n ",[Mine]),
	node(Prec,L,none,Mine,[]);
snode(Prec,[Mine,Left]) -> snode(Prec,[Left,Mine]) ;	

snode(Prec,Keys) ->
	%	io:format("Creating:~p~n ",[Keys]),
    {Left,[Mine|Rigth]}= lists:split(length(Keys) div 2,Keys), 
   % io:format("Creating:~c ~p ~p ~n ",[Mine,Left,Rigth]),        		
	L=spawn_link(?MODULE,snode,[self(),Left]),
	R=spawn_link(?MODULE,snode,[self(),Rigth]),	
	node(Prec,L,R,Mine,[]).
 

node(P,L,R,K,Store)-> 
	trap(false),		
	io:format("I am ~p and point to ~p an ~p key is ~c ~n",[self(),L,R,K]),
	%%%% Grade + 1	 add a store and make lookup and store handlers if world starts with Key store in the node
		receive	
			{lookup,K, Pid}->  Pid!Store,node(P,L,R,K,Store);	
			{lookup,V, Pid} when V>K -> R!{lookup,V, Pid} ,node(P,L,R,K,Store);
			{lookup,V, Pid}->  L!{lookup,V, Pid} ,node(P,L,R,K,Store);		

			{store,[K|Val]}->  node(P,L,R,K,[[K|Val]|Store]);
			{store,[V|Val]} when V>K->  R!{store,[V|Val]},node(P,L,R,K,Store);
			{store,[V|Val]}-> L!{store,[V|Val]},node(P,L,R,K,Store)	;
	%%%%Grade+1	 only the exit and link, the rest is grade 5
			%{'EXIT',P,Reason}-> io:format("my Parent side has died, life has no meaning~p!~n",[self()])	;			
			{'EXIT',R,Reason}-> io:format("my Right side has died~p!~n",[self()]), 
								Me=self(),
			                    spawn(fun()->recreate(Me,P,K,rigth)end),node(P,L,R,K,Store);
			{rigth,NR}->        link(NR),
								node(P,L,NR,K,Store);

			{'EXIT',L,Reason}-> io:format("my Left side has died~p!~n",[self()]),
								Me=self(), 
								spawn(fun()->recreate(Me,P,K,left)end),node(P,L,R,K,Store);	
			{left,NL}->        link(NL),
							   node(P,NL,R,K,Store)

			{gimmekey,Pid}-> Pid!{K},node(P,L,R,K,Store);				   
				
		end.
	%%%%%	


%				         <0.53.0>(5)
%			            /    	    \						
%			  <0.54.0>(3)            <0.55.0>(7)
%			  /        \                /      \	
%	 <0.56.0>(2)   <0.57.0>(4)   <0.58.0>(6)  <0.59.0>(8)
%		 /		
%   <0.60.0>(1)



%%%%Grade 5 

k(rigth,FK,K,Keys)-> lists:filter( fun(E)-> ((E>K) and (E<FK) and (K<FK)) or ((E>K) and (FK<K)) end,Keys);
k(left,FK,K,Keys)-> lists:filter( fun(E)-> ((E<K) and (K<FK))or ((E<K) and (K>FK) and (E>FK)) end,Keys).

recreate(Pid,P,K,Side)->
	P!{gimmekey,self()},	
	main!{gimmekeys,self()},

	Ks=receive 
			{main,Keys}-> receive 		
						{FK}-> k(Side,FK,K,Keys)
					  end	
	end,		
	io:format("Keys to recreate ~p~n",[Ks]),

	NR=spawn(?MODULE,snode,[self(),Ks]),
	Pid!{Side,NR}.
	

	


