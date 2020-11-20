-module(seventh).
-compile(export_all).
%cd("C:/Users/eannrea/OneDrive - Ericsson AB/Erla/2020").

ping()-> %% I am the shell :)
	io:format("This process is ~p~n",[self()]),
	Pid = spawn(fun pong/0),   % fun seventh:pong/0 %
		% fun()-> pong() end
	Data = "I am happy", 	
	Pid ! {ping, Data, self()},
	receive
		{pong,Var} -> Var;
		D-> D+1
	after 10000 -> pang

	end.	

pong()-> 1/0.
	%io:format("This process is ~p~n",[self()]).
	%,
	%receive
     % {ping, Data, PingId} -> PingId ! {pong,(Data--"happy")}
	%end.

map(F,L)-> 
		%lists:map(F,L).
		%lists:map(fun(E)-> F(E) end,L).
		%lists:map(fun(E)-> apply(F,[E])end,L),
		lists:map(fun(E)-> apply(fun()-> F(E) end, [])  end, L).
		
run(N)-> lists:foreach( fun(_)-> spawn(fun pong/0) end , lists:seq(1,N)).


% {0,ok}
% 74> erlang:system_info(process_limit).
% 262144
% 75> erlang:system_info(process_count).
% 38
% 76> process().
% ** exception error: undefined shell command process/0
% 77> processes().
% [<0.0.0>,<0.1.0>,<0.2.0>,<0.3.0>,<0.4.0>,<0.5.0>,<0.6.0>,
%  <0.9.0>,<0.41.0>,<0.43.0>,<0.45.0>,<0.46.0>,<0.48.0>,
%  <0.49.0>,<0.50.0>,<0.51.0>,<0.52.0>,<0.53.0>,<0.54.0>,
%  <0.55.0>,<0.56.0>,<0.57.0>,<0.58.0>,<0.59.0>,<0.60.0>,
%  <0.61.0>,<0.62.0>,<0.63.0>,<0.64.0>|...]
% 78> display(processes()).
% ** exception error: undefined shell command display/1
% 79> erlang:display(processes()).
% [<0.0.0>,<0.1.0>,<0.2.0>,<0.3.0>,<0.4.0>,<0.5.0>,<0.6.0>,<0.9.0>,<0.41.0>,<0.43.0>,<0.45.0>,<0.46.0>,<0.48.0>,<0.49.0>,<0.50.0>,<0.51.0>,<0.52.0>,<0.53.0>,<0.54.0>,<0.55.0>,<0.56.0>,<0.57.0>,<0.58.0>,<0.59.0>,<0.60.0>,<0.61.0>,<0.62.0>,<0.63.0>,<0.64.0>,<0.65.0>,<0.66.0>,<0.67.0>,<0.68.0>,<0.69.0>,<0.71.0>,<0.72.0>,<0.73.0>,<0.1337.0>]
% true
% 80> self().
% <0.1337.0>
% 81> c(seventh).                       
% seventh.erl:2: Warning: export_all flag enabled - all functions will be exported
% seventh.erl:18: Warning: this expression will fail with a 'badarith' exception
% {ok,seventh}
% 82> seventh:ping().                                        
% This process is <0.1337.0>
% =ERROR REPORT==== 22-Oct-2020::14:22:24.891000 ===
% Error in process <0.1346.0> with exit value:
% {badarith,[{seventh,pong,0,[{file,"seventh.erl"},{line,18}]}]}

% pang
% 83> c(seventh).    
% seventh.erl:2: Warning: export_all flag enabled - all functions will be exported
% seventh.erl:18: Warning: this expression will fail with a 'badarith' exception
% {ok,seventh}
% 84> seventh:ping().
% This process is <0.1337.0>
% ** exception exit: badarith
%      in function  seventh:pong/0 (seventh.erl, line 18)
% =ERROR REPORT==== 22-Oct-2020::14:23:21.090000 ===
% Error in process <0.1353.0> with exit value:
% {badarith,[{seventh,pong,0,[{file,"seventh.erl"},{line,18}]}]}

% 85> self().        
% <0.1354.0>
