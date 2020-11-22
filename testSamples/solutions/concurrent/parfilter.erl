
-module(parfilter).
-compile(export_all).


%start() ->
  %pfilter(fun(X) -> X < 2 end, [1,0,1]). % === [1,0,1]
  %parent([1,2,3,4]).


pfilter(Pred, List) ->
    Parent = register(parent, self()),

    No_of_elem_in_list = length(List),
    Pids = lists:map(fun(_) -> spawn(?MODULE, pfilter_helper, [Pred, List]) end, lists:seq(1,No_of_elem_in_list)),
    io:format("pids : ~p~n", [Pids]).




pfilter_helper(F, List) -> 
  Self=self(),
  io:format("pfilter worker pid ~p~n", [Self]).
