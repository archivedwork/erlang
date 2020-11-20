-module(fifth).
-compile(export_all).
%cd("C:/Users/eannrea/OneDrive - Ericsson AB/Erla/2020").

%Eg. swap("Hi my FRIENDS")=="hI MY friends"

%tail
			% List, InitialAccumulator	
swap(S)-> swap(S,[]).

swap([],Acc)-> lists:reverse(Acc);

swap([HC|TC],Acc) when (HC>=$a) and (HC=<$z) -> 
	swap(TC,[HC-32|Acc]);

swap([HC|TC],Acc) when (HC>=$A) and (HC=<$Z) -> 
	swap(TC,[HC+32|Acc]);

swap([HC|TC],Acc)-> swap(TC,[HC|Acc]).

swapu([],Acc)->Acc;%lists:flatten(lists:reverse(Acc));
swapu(S=[HC|TC],Acc)-> swapu(TC,Acc++upperLower(S)).%[upperLower(S)|Acc]).

upperLower(C) when ($a =< hd(C)) and (hd(C) =< $z) -> hd(C) + ($A - $a);
upperLower(C) when ($A =< hd(C)) and (hd(C) =< $Z) -> hd(C) - ($A - $a);
upperLower(C) -> C.


%foldl   lists:foldl(Function(Element,Accumulator)
      %              , InitialAccumulator,List    )

swapfold(S)-> 
lists:reverse(
	lists:foldl(fun(E,Acc) when (E>=$a) and (E=<$z) ->[E-32|Acc]; 
            (E,Acc) when (E>=$A) and (E=<$Z) ->[E+32|Acc];
 			(E,Acc)->[E|Acc] end,[],S)
	).	      

%merge
merg([A|AT],L2=[B|_BT]) when A<B -> [A|merg(AT,L2)] ;
merg(L1=[A|_AT],[B|BT]) -> [B|merg(L1,BT)] ;
merg(L1,L2)-> L1++L2.

%map elements

mapme(_,[])->[];
mapme(F,[E|T])-> [F(E)|mapme(F,T)].

%check condition
check(C,L)-> check(C,L,[[],[]]).

check(_,[],[B,G])-> [lists:reverse(B),lists:reverse(G)];
check(C,[E|T],[B,G])-> 
     Condition=C(E),

     case Condition of
     	true-> check(C,T,[B,[E|G]]);
     	_-> check(C,T,[[E|B],G])
     end.	


check2(C,L)-> G=lists:filter(C,L), [L--G,G].


 %f(A)when is_atom(A) ->;
  %f(A)->.

  %f(A)-> case is_atom(A) of

  %			true -> 
  %			_->
  %		end.	 

  %update_values([{melinda,fun(X) -> 10*X end}], 1000, #{melinda=>12, anna=>24}) == #{anna => 24,melinda => 120}
	
update([{H, F} | T], Init, Map) ->
	case Map of
		#{H := Value} ->
			update(T, Init, Map#{H:=F(Value)});
		_ -> 
			update(T, Init, Map#{H=>Init})
	end;
update(_,_, Map) ->
    Map.

%Make a function pipemap(FList,EList).

pipemap(FList, EList) ->
    lists:map(fun(H) -> pipe(FList, H) end,
		  EList).
    
pipe([F | Fs], E)->
    pipe(Fs, F(E));
pipe([], E) ->
    E.
