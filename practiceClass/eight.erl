-module(eight).
-compile([export_all]).

%% code won't compile, you need to fix the change from Count to Ref :)

%F, [1,2,3]   W1 M ! F (1)   W2 M!F (2) W3 M!F (3)

%spawn(method)
%% N=3     [1,2,3,4,5]
parmapn(N,F,L)->
	  
      WPids=lists:map(fun(E)-> spawn(worker()) end,lists:seq(1,N)),	
      Coll= spawn(?MODULE,collector,[]),
      Coll!{list,lists:seq(1,length(L))},
      Disp= spawn(?MODULE,dispatcher,[F,L,Coll,0]),
      register(disp,Disp).	

%dispatcher(_,_,[],_)-> ok;
%dispatcher([],F,L,C)-> 
	%	receive
	%		{free,Pid}-> dispatcher([Pid],F,L);	
	%	end;		
	% [  ID 2 ID3]		
%dispatcher([WH|WPids],F,[E|ET],C)-> 
%	               WH!{job,F,E,C},
%	               dispatcher(WPids,F,ET).
collector()->
 receive
 {list,L}-> collector(L)
 end.	
%collector()-> collector(lists:seq(1,length(L)). 

collector([])-> [];
collector([HE|TE])->
	receive
	{HE,Res}-> [Res] ++ collector(TE)
	end.

dispatcher(_,[],_,_)-> ok;
dispatcher(F,[EH|ET],C)->
		receive     
		  {free,Pid}->Ref =make_ref(),	Pid!{job,F,EH,C,Ref}, dispatcher(F,ET,C)
		end.

worker()->
	Disp= whereis(disp),
	Disp!{free,self()},
	receive
		{job,F,E,C Count}-> C!{Count,F(E)}, worker()
	end.	




%%%%


pmap_ord(F,L)->
	Me=self(),
	%spawn(fun()->worker(Me,F,E) end).
    %Pids=lists:map(fun(E)-> spawn(fun()->  Me!F(E) end) end,L),
    Pids=send(Me,F,L,[]),
    rec(Pids,[]).

send(_,_,[],Pids)-> P=lists:reverse(Pids), 
	io:format("send order: ~p~n",[P]),P;
															%E	
send(Me,F,[HE|T], Pids)-> 

    Pid=spawn(fun()->  Me!{self(),F(HE)} end),
    io:format("Sending ~p to ~p ~n",[HE,Pid]),
    NP=[Pid|Pids],
	send(Me,F,T,NP).


rec([],Res)-> lists:reverse(Res);
	%L
	%166
rec([PH|T],Res)->
	receive 
		{PH,Val}-> rec(T,[Val|Res]);
		Anything ->  {Anything,unexpected}	
	after 1000 -> ohohoh	
	end.

%worker(Master,F,E)->
%	Master!F(E).

%pmap_ord() 
