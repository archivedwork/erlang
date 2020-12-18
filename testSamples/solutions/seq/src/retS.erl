
-module(retS).
-compile(export_all).



doubleZip([], [])                        -> [];
doubleZip([], ValList)                   -> [{leftover, ValList}];
doubleZip(_Keys, [])                     -> []; 
doubleZip([KH|KT], ValList=[VH|[]])      -> [{KH, [VH]}];
doubleZip([KH|KT], [VH1, VH2|VT])        -> [{KH, [VH1,VH2]}] ++ doubleZip(KT, VT).




%% there are two extra elements in the result of this retS:marginCut([1,2,3,4,5,6,7,8,9],3,2).
%% i know i do not know why ->  "\b\t","\t" 

%% when the list leftover is smaller than S you do not need margins enimore, you should just return it 
marginCut([], S, M)                     -> [];
marginCut(L=[HL|HT], S, M) when S == M  -> L;
marginCut(L=[H|T], S, M)   when S > M       -> [lists:sublist(L, S)] ++ marginCut(T, S, M).
%%marginCut(L, S, M) when length(L) < S -> [].




%funMultiplier(F) -> G;
%funMultiplier(F(N)) -> F(L, true or false);

% where do u get the lists element in test cases?
%G1([[14],[4,7],[5,6]], fun(E)->length(E)>0  end)

%G1 = retS:funMultiplier(fun erlang:length/1).       <- returns function                                    
%G1([[14],[4,7],[5,6]], fun(E)->length(E)>0  end) == [1,2,2]. <- apply function to [[14],[4,7],[5,6]]  using  fun(E)->length(E)>0  end as the condition


g(L=[H|T], F) -> lists:map(F, L).





counter(D) -> D +1.

%retS:compareMaps(#{it=> ciao}, #{it=>ciao})==0.  
compareMap(Fmap1, Fmap2) when Fmap1 =:= Fmap2  -> 0;
%compareMap(Fmap1, Fmap2) when maps:keys(Fmap1) == maps:get(length(maps:keys(Fmap1),Fmap2) -> counter(1);
compareMap(Fmap1, Fmap2) when Fmap1 =/= Fmap2 -> counter(0).




