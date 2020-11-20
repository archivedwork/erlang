-module(nine).
-compile([export_all]).

%cd("C:/Users/eannrea/OneDrive - Ericsson AB/Erla/2020").

call()->
    receive
    	hello -> caller! hi, call();
    	goodbay-> caller! ok;
    	 _ -> caller! 'what?'
	end.   
	

phone()->   register(caller,self()),
			start_call().


start_call()->  RPid=spawn(fun()-> restartcall() end),
				receive
					{call,Pid}-> {RPid,Pid}	
				end.


restartcall()->
		process_flag(trap_exit,true),
		Pid=spawn_link(?MODULE,call,[]),
		caller!{call,Pid},
		receive
			{'EXIT',Pid,Reason}-> 
				io:format("our call was hung up because of ~p~n",[Reason]),
				restartcall();
			quit-> dead	
		end.