-module(check).
-compile(export_all).


divide_fail() ->
        10 div 2 .  
         %1 / 0.

child() ->
  divide_fail().


parent() ->
  process_flag(trap_exit, true),
  {Pid, Ref} = spawn_monitor(?MODULE,child,[]),
  receive
    {'EXIT',Pid,Ref,Reason} ->
        io:format("reason : ~p~n ~p~n",[Reason, Ref])
  end.