-module(fourth).
-compile(export_all).
% cd("C:/Users/eannrea/OneDrive - Ericsson AB/Erla/2020").


cval(_V,[])->0;
cval(V,[H|T])->
    if 
    	V ==H -> 1 + cval(V,T);
        true -> cval(V,T)
    		
   end.
%%[{H,Count}|T]  [1,3,1,3,2,3,2,1,1] -> [{1,2} ,{3,1}]

%count([])-> [];
%count([H|T])->
 % Count = cval(H,T),
  %[{H,Count+1}| count(T)].

count([])-> [];
count([H|T])->
 Count = cval(H,T),
 NT = lists:filter(fun(E)-> E /= H end,T),
 [{H,Count+1}| count(T)].


count2([],_)-> [];
count2([H|T],Counted)->
    Check= lists:member(H,Counted),
	case Check of
		true -> count2(T,Counted);
			_->	[{H,cval(H,T)+1} | count2(T,[H|Counted])]	
	end.




del(_,Acc,0)-> Acc; 
del(E,L,C)-> del(E,L--[E],C-1).


applyF(E)->

  F= fun([B])-> B+2 ;
  	    (A)-> A end.
  F(E).


appLy(E,F)-> F(E).

%%
%del(E,[E|T],C)->del(E,T,C-1);
%del(E,[H|T],C)->del(E,T++[H],C).


%del(E,[H|T],C)-> 

 %case H of
 %	E-> del(E,T,C-1);
 %	_-> del(E,T++[H],C)
 %end.

%del(E,[H|T],C)-> 
 %if 
  %  E==H -> del(E,T,C-1);
   % true -> del(E,T++[H],C)
 %end.	



%del(H,[H|T])-> [del(T)],
%del(V,[H|T]) -> [H|...]


%%

%subsum(L)-> subsum(L,[]).

%%% [1,2,3]  1 3 6    [6,3,1]

%subsum([],Acc)-> lists:reverse(Acc);
%subsum([H|T],[])-> subsum(T,[H]);
%subsum([H|T],Acc=[HA|_])-> subsum(T,[H+HA|Acc]).










