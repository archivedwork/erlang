-module(tenth).
-compile([export_all]).

%cd("C:/Users/eannrea/OneDrive - Ericsson AB/Erla/2020").
		% # Workers Func to run 

init(W,J)-> spawn(?MODULE,start,[W,J]).
start(W,J)-> %init trapexit  State  spawn workers 
			register(master,self()),
			ReP= lists:map(fun(_)-> spawn_monitor(?MODULE,worker,[]) end,lists:seq(1,W)),			
			send(ReP,J),
			io:format("this are the workers: ~p~n",[ReP]),
			rec(J).	
%startring(N)-> %init trapexit  State  spawn workers 
%				Me=self(),
%			Pids= lists:foldl(fun(_,Next)->spawn_monitor(?MODULE,worker,[Next])end,Me,lists:seq(1,N)),
%			lists:last(Pids)!messagetoring	
%			worker().

%init(0,ACC) ->ACC;
%init(W,ACC=[HA|TA])->
 %   init(W-1,[spawn(?MODULE,node,HA)|ACC]).			

%%% pid 1 2 3    2 3 1 
%sendnext(AllP=[P|Pids])->  
%	LNext= Pids ++[P],
%	helper(AllP,LNext).
	
	%lists:foldl( fun(Pi,[NP|Acc])-> Pi! {nextis,NP}, Acc   end  ,LNext,AllP).
%helper([HP|Pids],[HN|NPids])-> HP !{next,Pids}, helper(Pids,NPids).

send(ReP,J)-> lists:foldl( 
	fun(Job,[{P,R}|Acc])-> P!{workthis,Job}, Acc++[{P,R}]   end  ,ReP,J).

%sendandrec(Pids,[],[{J,P,_}|JR])-> 
%	receive
 %      {res,J,P,Res}-> [{J,Res}| sendandrec(Pids,[],JR)]
%	end	;

%sendandrec([],Jobs,JR)-> 
%	receive
%		{done,Pid}-> sendandrec(Pid,Jobs,JR)
%	end	;

%sendandrec([P|Pids],[HJ|Js],JRegister)-> 
%			P! {workthis, HJ},
%			[{HJ,P}|JRegister].

%rec([])-> [];
rec(Results)->
	receive 
		{res, Res} -> rec([Res| Results]);
		{'DOWN',Ref,_,_,youdie}-> rec(Results);
		{'DOWN',Ref,_,_,Reason}-> 
			io:format("Restarting worker that died because of ~p~n",[Reason]),
			NPid=spawn_monitor(?MODULE,worker,[]),
			io:format("this is the new worker: ~p~n",[NPid]),
			rec(Results)
	end.

worker()-> 
 receive
 	{workthis,Job}-> worker(Job) 
 end.

worker(Fun)->
	receive
		{workthis,Job}-> worker(Job); 
		quit-> ok;
		{compute, Element, Pid} ->
			Res=Fun(Element), 
			Pid!Res, 
			master!Res, 
			%worker(Fun)
	end.	

kill(Pid)-> %Pid!quit; 
		exit(Pid,youdie).

%loop()->