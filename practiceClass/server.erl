-module(server).
-compile(export_all).
%cd("C:/Users/eannrea/OneDrive - Ericsson AB/Erla/2020").

%{server, 'server@186.'}
%{server, 'whatever@localhost' }

%%% user interface/ client interface

u_login(Name)->
			%server!{login,UserPid,Name} cannot work
			global:send(server,{login,self(),Name}),
			receive
				logged ->  ok;
				notpossible-> 'server is full'
 			after 1000-> serverout	
			end.

u_msg(Msg)-> global:send(server,{msg,self(),Msg}).	

%% logout 

u_logout()->ok.


%%%%%%%%% server implementation

start(NU)-> %register
			global:register_name(server,spawn(fun()-> init(NU) end)).

init(NU)-> %% trap exit if needed here 
			%eventually create a worker pool / spawned 
			InitState={NU,#{}},
			loop(InitState). 

loop(State)-> 
		receive
			stop -> io:format("terminated!");
			{login,UserPid,Name}-> NState=login_handler(UserPid,Name,State), loop(NState);	
			{msg, UserPid, Msg} -> NState=msg_handler(UserPid,Msg,State), loop(NState);
			{logout,...}->
		end.	


%% backend
login_handler(UserPid,_,State={0,_} )->  
		UserPid!notpossible, 
		State;

login_handler(UserPid,Name,State={MaxU,Users})->
	NUsers =Users#{UserPid=>Name},
	UserPid ! logged,
	{MaxU -1 , NUsers}.

	


msg_handler(UserPid,Msg,State={_,Users})->
	case Users of
		#{UserPid := UName}->
					NMsg= "("++UName++") : "++Msg,
					maps:fold( fun( UPid,_Name,_Acc)->  UPid!{msg, NMsg} ,ok,Users );
		_-> io:format("not autorized access ~p~n",[UserPid])
	end,
	State.				


