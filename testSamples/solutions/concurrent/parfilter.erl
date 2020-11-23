
-module(parfilter).
-compile(export_all).


%start() ->
  %pfilter(fun(X) -> X < 2 end, [1,0,1]). % === [1,0,1]
  %parent([1,2,3,4]).


pfilter(Pred, List) ->
    register(parent,self()), %% what is his problem with this
    No_of_elem_in_list = length(List),
    Pids = lists:map(fun(_) -> spawn(?MODULE, pfilter_helper, [Pred, List]) end, lists:seq(1,No_of_elem_in_list)),
    io:format("pids : ~p~n", [Pids]),
    rec([]).




%% shall we try it? maybe why not let try 

% The parent process puts the element into the result list if function F evaluated to true. 
% how to check if it is working or not ? we need receive somewhere? missing rec and returning the list, yes we need to store it 

pfilter_helper(F, []) -> Main = whereis(parent), Main ! false;
pfilter_helper(F, List=[LH|LT]) -> 
  Self=self(),
  Main = whereis(parent),
  %% you need to get the pid of the regitered name parent yes in case u want to save it in variable Main but it works if u just call it do u know we did not give anything in rec([]) we give empty list maybe this is the problem?no this is not the problem , the first one is [] and then we are building it from receive
  io:format("pfilter worker pid is ~p~n", [Self]),%% what is X ?  should it be F(LH) ? yes
  %Elem = fun(X) -> F(X) end,        % get element by element something wrong here
  %io:format("Elem ~p~n", [Elem]),
  case F(LH) of  % is this logic correct?
    true ->
      io:format("Sending ~p to main ~p ~n", [LH, Main]),
      Main ! {true, LH},   % send the result to parent process yes somewhere here, why not to receive true then we save true in a variableand repeat again i mean in rec(L), but you need to concat the result ok good point
     %test2:pfilter(fun(X) -> X < 2 end, [1,0,1]) == [1,0,1] like this [1,0,1], so question here, do we need ring?
     %% no man no need just list concat ++ ,okay i am not sure if we can send message without {} you can man it is an atom u can send it as message
      pfilter_helper(F, LT); % do we need to remove looping from here?

    false ->
      io:format("Sending false of  ~p to main ~p ~n", [LH, Main]),
      pfilter_helper(F, LT)
      %% Main ! false   % send the result to parent process I think here when first element is false it is returning fale to main and hence [] even if previous elements were true so we need to skip and check others untill all are false
      %%% even, [2,4,3,2,1]  okin this case 2 true 4 true 3 false it stops but it should continue to other and return [2,4,2] ... get it? yes so here still we need when all are false to return false ok we can keep looping whe ne the list is empty return false
  end.

 rec(L) ->
  receive
   {true, LH} -> io:format("received element is ~p~n", [LH]), rec([LH|L]);    % so here concat and loop ok
   false -> nothing %io:format("false element is"), []         % or u can write atom false -> nothing but the result is [] in false cases not atom , lets try it after 
  after 1000 -> something_wrong_rec
  end.
