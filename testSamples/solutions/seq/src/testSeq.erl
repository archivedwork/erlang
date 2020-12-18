
-module(test).
-compile(export_all).



%Task no. 1: upDown be careful leaving random text uncommented
% ok
% anna I lose what i wrote in replit in updown function i do not know why i have to write it again 

upDown(0, _Lst) -> stop;
upDown(N, Lst)  -> upDown_helper(N, Lst, 1, goup). %updown

upDown_helper(N, [], Counter, Flag) -> [];
upDown_helper(N, Lst=[H|T], Counter, Flag) ->  
  if 
  (Flag =:= goup)  -> 
        case Counter == N of
          true -> [{Counter, H}] ++ upDown_helper(N, T, Counter - 1, godown);
          _    -> [{Counter, H}] ++ upDown_helper(N, T, Counter + 1, goup)
          end;

  true -> 
          case Counter == 1 of
            true -> [{Counter, H}] ++ upDown_helper(N, T, Counter + 1, godown);
            _  -> [{Counter, H}] ++ upDown_helper(N, T, Counter - 1, goup)
          end
  end.





% Task no. 3: cutMove

% cutMove(list(),integer(),integer()) -> list()
%> test:cutMove([],1,3).
%[]

%> test:cutMove([1,2,3,4,5,6,7],1,3).
%[1,2,4,5,6,7,3]

%> test:cutMove([1,2,3,4,5,6,7],3,5).
%[1,2,3,4,5,6,7]

%> test:cutMove([1,2,3],3,5). 
%[1,2,3]

%cutMove([], _S, _P) -> [].


%% you should us length(L) 
% ok


cutMove([], S, P) -> [];
cutMove(Lst, S, P) -> cutMoveHelper(Lst, S, P, 0). 


cutMoveHelper(Lst=[H|T], S, P, Counter) ->
 if
   P > length(Lst)      -> Lst;
   true                -> 
   cutMoveHelper(T, S, P, Counter-1) ++ [S]
 end.






%Task no. 4: randApply
%%Make a function randApply/2 that takes a function F and a list L. For as many times as there are elements in the list L, take a random element from it and substitute it with the result of applying F to it. You can use rand:uniform(N) to create a random number from 1 to N. Make sure that at every substitution you print the value that is changing like in the examples below.

% randApply(fun(),list()) -> list()
randApply(F, Lst) -> randHelper(F, Lst, [], length(Lst)).


randHelper(_, [], ResLst, Counter)   -> ResLst,
io:format("Changing element in position: ~p~n, New list  ~p~n", [Counter,ResLst]);
randHelper(F, Lst=[H|T], ResLst, Counter) -> 
  Rand = rand:uniform(H),
  randHelper(F, T, [F(Rand)]++ ResLst, Counter-1).