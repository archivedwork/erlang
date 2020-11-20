-module(eight).
-compile([export_all]).
%-export()
%cd("C:/Users/eannrea/OneDrive - Ericsson AB/Erla/2020").

% eight:parmapn(3,fun(E)-> E+1 end,[1,2,3,4,5]).   

% workers are monitored if worker dies unexpectedly it gets respawned

parmapn(N,F,L)->
	  Jobs = lists:map(fun(E)-> {make_ref(),E} end ,L),
	  Coll= spawn(?MODULE,collector,[Jobs,[],self()]),
	  Disp= spawn(?MODULE,dispatcher,[F,Jobs]),
      register(disp,Disp),
      WPids=lists:map(fun(E)-> spawn(fun()-> worker(Coll)end) end,lists:seq(1,N)), %%% 
      %lists:foreach(fun(_)-> spawn(worker(Coll)) end,lists:seq(1,N)),		    
      receive
      	{Coll,Res}->  kill(WPids), Res
      after 1000 -> something_wrong
      end.	

kill([])-> unregister(disp);
kill([PH|PT])-> exit(PH,quit), kill(PT).

collector([],Acc,Main)->  io:format("Results ~p to ~p~n",[Acc,Main]), Main!{self(),Acc};
collector([{Ref,E}|TJ],Acc,Main)->
	receive
	{Ref,E,Res}->  io:format("Collecting ~p~n",[E]),
				collector(TJ, Acc++[Res],Main)
	end.

dispatcher(_,[])-> 
		receive
        after 10000-> ok end;	

dispatcher(F,[{HRef,HE}|ET])->
		receive     
		  {free,Pid}->	
		  			io:format("sending ~p to ~p~n",[HRef,Pid]),
		  			Pid!{job,F,HE,HRef}, 
		  			dispatcher(F,ET)
		end.

worker2(Coll)->
	Disp= whereis(disp),
	case Disp of
		undefined -> io:format("i am dead ");
		_-> Disp!{free,self()},
			receive
				{job,F,E,HRef}-> io:format("~p is working ~p~n",[self(),HRef]),
							Coll!{HRef,E,F(E)}, 
							worker(Coll)
			end	
	end.	

worker(Coll)->
	Disp= whereis(disp),
	Disp!{free,self()},
		receive
			{job,F,E,HRef}-> io:format("~p is working ~p~n",[self(),HRef]),
						Coll!{HRef,E,F(E)}, 
						worker(Coll)	
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
