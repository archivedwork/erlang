-module(third).

-compile(export_all).


multiply(A,B)-> A*B.

%%%%%%%%% list member mutiplication

prod([])-> 1;      %%% [1|[2|[]]]    H1  T[2|[]] H2  []   H[]  1
prod([H|T])->
	H*prod(T).

prod_tail(L)->  prod_tail(L,1).

prod_tail([],Acc)-> Acc;
prod_tail([H|T], Acc )->  prod_tail(T, H*Acc).


%%%%%% find item in a list


%search(E,[H|T])when E==H->  true.
search(_E,[])-> false;
search(E,[E|T])-> true;
search(E,[H|T])-> search(E,T).


%%search1(E,L)-> hd(L)
search1(_E,[])-> false;
search1(E,[H|T])-> (E==H) or search1(E,T).

%% example counter recursion
sidx(E,L)-> sidx(E,L,1).

sidx(_E,[],C)-> nowere;
sidx(E,[E|T],C)-> C;
sidx(E,[H|T],C)-> sidx(E,T,C+1).


anything([])-> [];
%anything(F) when is_function(F,1) -> F(12);  
anything([H|T])-> [one] ++ anything(T).

				%%%%  [1,2]   [2]     [],[one| [one|[]]]   [one,one]


%%% how to tail rec using list accumulator
anything2(L)-> lists:reverse(anything2(L,[])).

anything2([],Acc)-> Acc;
anything2([H|T],Acc)->  anything2(T,[one|Acc]).


% Erlang/OTP 22 [erts-10.5] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]

% Eshell V10.5  (abort with ^G)
% 1> cd("c:/Users/Desktop").
% c:/Program Files/erl10.5/usr
% ok
% 2> cd("c:/Users/eannrea/Desktop").
% c:/Users/eannrea/Desktop
% ok
% 3> c(third).                      
% third.erl:3: Warning: export_all flag enabled - all functions will be exported
% {ok,third}
% 4> third:multiply(3,4).
% 12
% 5> third:multiply(atom,4).
% ** exception error: an error occurred when evaluating an arithmetic expression
%      in operator  */2
%         called as atom * 4
%      in call from third:multiply/2 (third.erl, line 6)
% 6> third:multiply(2.6,4). 
% 10.4
% 7> c(third).              
% third.erl:3: Warning: export_all flag enabled - all functions will be exported
% {ok,third}
% 8> third:prod([2,3,1]).  
% 6
% 9> third:prod_tail([2,3,1],1).
% 6
% 10> c(third).                  
% third.erl:3: Warning: export_all flag enabled - all functions will be exported
% {ok,third}
% 11> third:prod_tail([2,3,1]).  
% 6
% 12> c(third).                  
% third.erl:3: Warning: export_all flag enabled - all functions will be exported
% third.erl:23: Warning: variable 'T' is unused
% {ok,third}
% 13> third:search(2,[2,3,1]). 
% true
% 14> third:search(3,[2,3,1]).
% ** exception error: no function clause matching third:search(3,[2,3,1]) (third.erl, line 23)
% 15> c(third).               
% third.erl:3: Warning: export_all flag enabled - all functions will be exported
% third.erl:25: Warning: variable 'T' is unused
% third.erl:26: Warning: variable 'H' is unused
% {ok,third}
% 16> third:search(3,[2,3,1]).
% true
% 17> c(third).               
% third.erl:3: Warning: export_all flag enabled - all functions will be exported
% third.erl:25: Warning: variable 'T' is unused
% third.erl:26: Warning: variable 'H' is unused
% {ok,third}
% 18> third:search1(3,[2,3,1]).
% true
% 19> third:search1(4,[2,3,1]).
% false
% 20> third:search1(2,[2,3,1]).
% true
% 21> [1,2,3]++[4,5].
% [1,2,3,4,5]
% 22> [1,2,3]--[4,5].
% [1,2,3]
% 23> [1,2,3]--[3,2].
% [1]
% 24> hd([1,2,3]).
% 1
% 25> tl([1,2,3]).
% [2,3]
% 26> length([1,2,3]).
% 3
% 27> c(third).                
% third.erl:38: function search/3 undefined
% third.erl:3: Warning: export_all flag enabled - all functions will be exported
% third.erl:25: Warning: variable 'T' is unused
% third.erl:26: Warning: variable 'H' is unused
% third.erl:36: Warning: variable 'C' is unused
% third.erl:37: Warning: variable 'T' is unused
% third.erl:38: Warning: variable 'H' is unused
% error
% 28> c(third).
% third.erl:3: Warning: export_all flag enabled - all functions will be exported
% third.erl:25: Warning: variable 'T' is unused
% third.erl:26: Warning: variable 'H' is unused
% third.erl:36: Warning: variable 'C' is unused
% third.erl:37: Warning: variable 'T' is unused
% third.erl:38: Warning: variable 'H' is unused
% {ok,third}
% 29> third:sidx(2,[2,3,1]).   
% 1
% 30> third:sidx(3,[2,3,1]).
% 2
% 31> third:sidx(5,[2,3,1]).
% nowere
% 32> lists:zip([1,2,3],[apple,orange,melon]).
% [{1,apple},{2,orange},{3,melon}]
% 33> lists:zip([1,2,3],[apple,orange]).      
% ** exception error: no function clause matching lists:zip([3],[]) (lists.erl, line 387)
%      in function  lists:zip/2 (lists.erl, line 387)
%      in call from lists:zip/2 (lists.erl, line 387)
% 34> lists:zip([1,2,3],{apple,orange}).
% ** exception error: no function clause matching 
%                     lists:zip([1,2,3],{apple,orange}) (lists.erl, line 387)
% 35> #{}.
% #{}
% 36> #{key => 2}.
% #{key => 2}
% 37> Va= 12.     
% 12
% 38> #{key => Va}.
% #{key => 12}
% 39> #{anything => Va}.
% #{anything => 12}
% 40> a. 
% a
% 41> [a,b,c]. 
% [a,b,c]
% 42> $a.    
% 97
% 43>    
% 43> $A. 
% 65
% 44> 
% 44> $A-$a
% 44> .
% -32
% 45> $b-$B.
% 32
% 46> $a > $A.
% true
% 47> X= $d.  
% 100
% 48> X> $a .
% true
% 49> X< $z .
% true
% 50> c(third).                               
% third.erl:3: Warning: export_all flag enabled - all functions will be exported
% third.erl:25: Warning: variable 'T' is unused
% third.erl:26: Warning: variable 'H' is unused
% third.erl:36: Warning: variable 'C' is unused
% third.erl:37: Warning: variable 'T' is unused
% third.erl:38: Warning: variable 'H' is unused
% third.erl:43: Warning: variable 'H' is unused
% third.erl:47: Warning: variable 'H' is unused
% {ok,third}
% 51> third:anything([1,2,3]).
% [one,one,one]
% 52> c(third).               
% third.erl:3: Warning: export_all flag enabled - all functions will be exported
% third.erl:25: Warning: variable 'T' is unused
% third.erl:26: Warning: variable 'H' is unused
% third.erl:36: Warning: variable 'C' is unused
% third.erl:37: Warning: variable 'T' is unused
% third.erl:38: Warning: variable 'H' is unused
% third.erl:43: Warning: variable 'H' is unused
% third.erl:48: Warning: variable 'H' is unused
% {ok,third}
% 53> third:anything2([1,2,3]).
% ** exception error: undefined function third:anything2/1
% 54> c(third).                
% third.erl:3: Warning: export_all flag enabled - all functions will be exported
% third.erl:25: Warning: variable 'T' is unused
% third.erl:26: Warning: variable 'H' is unused
% third.erl:36: Warning: variable 'C' is unused
% third.erl:37: Warning: variable 'T' is unused
% third.erl:38: Warning: variable 'H' is unused
% third.erl:43: Warning: variable 'H' is unused
% third.erl:48: Warning: variable 'H' is unused
% {ok,third}
% 55> third:anything2([1,2,3],[]).
% [one,one,one]
% 56> lists:reverse([1,2,3]).
% [3,2,1]
