%%%-------------------------------------------------------------------
%%% @author mo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Oct 2020 18:30
%%%-------------------------------------------------------------------
-module(test).
-author("mo").

%% API
-compile(export_all).


% ----------- from book --------------
geom(N1, N2) -> N1 * N2.


% pattern matching
area(rectangle,N1, N2 ) -> N1*N2;
area(triangle, N1, N2)  -> (N1 * N2) div 2;
area(ellipse, N1, N2)   -> math:pi() * N1 * N2.


%tuples
areaTup({Shape, Dim1, Dim2}) -> area(Shape, Dim1, Dim2).



gcd(M, N) ->
  if
    M == N -> M;
    M >  N -> gcd(M-N, N);
    true   -> gcd(M, N - M)
  end.


%powers === raise

%powers with Head Recursion
powers(_, 0) -> 1;
powers(X, 1) -> X;
powers(X, N) when X > 0 -> X * powers(X, N-1);
powers(X, N) when N < 0 -> 1.0 div powers(X, N).



% Tail recursion with an Accumulator
raise(_, 0)                -> 1;
raise(X, N) when  N < 0      -> 1.0 div raise(X, -N);
raise(X, N) when N > 0     -> raise_helper(X, N, 1).

raise_helper(_, 0, Acc)  -> Acc;
raise_helper(X, N, Acc)  -> raise_helper(X, N-1, X * Acc).


% below code let you see the output of the recursion, tracing raise2
%raise22(_, 0)     -> 1;
%raise22(X, 1)     -> X;
%raise22(X, N)   when N > 0  ->
%  io:format("Enter X: ~p, N: ~p~n", [X, N]),
%  Result = X * raise22(X, N-1),
%  io:format("Result is ~p~n", [Result]).
  % ,Result;
%raise22(X, N) when N < 0 -> 1.0 div raise22(X, N).


%------------- book ------------------







% when
even(N) when N rem 2 == 0 -> true;
even(_)                   -> false.


% case ... of
even1(N) ->
  case N rem 2 == 0 of
    true    -> true;
    false   -> false
  end.



% len([1,2,3,4]) == 4
len([]) -> 0;
len([_|T])  -> 1 + len(T).



dowhile(0) -> 0;
dowhile(N) ->
  NO = N -1,
  io:format("~w~n", [NO]),
  dowhile(NO).



sum(L) -> summ(L, 0).

summ([], Acc)       -> Acc;
summ(L=[H|T], Acc)  ->
  Acc0 = Acc + H,
  summ(T, Acc0).



fac(N) -> fac(N, 1).

fac(0,Acc)    -> Acc;
fac(N, Acc)  when N>0 -> fac(N-1, N*Acc).



%split(L, Pivot) -> splitting(L, Pivot, [], []).

%splitting([], _ , Smaller, Bigger)                           -> {Smaller, Bigger};
%splitting(L=[H|T], Pivot, Smaller, Bigger)  when H >= length(Pivot) -> splitting(T, Pivot, Smaller, [H|Bigger]);
%splitting(L=[H|T], Pivot, Smaller, Bigger)  when H < length(Pivot)  -> splitting(T, Pivot, [H|Smaller], Bigger).



% Head recursion
range1(N, N)       -> [N];
range1(Min, Max)  when Min < Max -> [Min|range(Min+1, Max)].



% tail recursion
range(Min, Max) -> rangeT(Min, Max, []).


rangeT(Max, Max, Result) 				-> Result;
rangeT(Min, Max, Result) when Min < Max -> rangeT(Min+1, Max, Result++[Min]);
rangeT(_,_,_)							-> out_of_bound.




%----------- test.txt solutions -------------


% test:multiplier(12,3)==(12*3).
% test:multiplier(0,0)== forbidden.
% test:multiplier(7,0)== forbidden.

halve(N) -> N div 2.

double(N) -> N * 2.

is_even(N) when N rem 2 == 0  -> true;
is_even(N) when N rem 2 =/= 0 -> false.

% TODO: still need to finish
multiplier(L, R) when (L =< 0) or (R =< 0) -> forbidden;
multiplier(L, R) -> (halve(L) * double(R)).





% test:is_numeric("123") ==true.
%test:is_numeric("12.3")==true.
%test:is_numeric(".12.3")==false.
%test:is_numeric(".12.3.")==false.
%test:is_numeric("123.")==false.
%test:is_numeric("")==false.

is_numeric("")        -> false;
is_numeric([H|_])   ->  not lists:member($., [H]);
is_numeric([_|T])   -> true;
is_numeric([H|_])   -> lists:member([H], lists:seq($0, $9)).





% ------------ retake18-spring.txt solutions------------
% partition using Tail recursion

% partition([1,2,3,4], 2) == [[1,2],[3,4]]
% partition([1,2,3,4,5],2) == [[1,2],[3,4],[5]]
partition(L, D) -> partition_helper21(L, D, []).


partition_helper21([], _, Result_lst) -> Result_lst,
io:format("Result list ~p ~n",[Result_lst]);

partition_helper21(L, D, Result_lst) when D > length(L) -> Result_lst++[L];
partition_helper21(L, D, Result_lst) ->
  % print out initial Result_lst
  io:format("Result list ~p ~n",[Result_lst]),

  % split return [{Head, Tail}]
  {Head,Tail} = lists:split(D, L),

  %print out {Head, Tail}
  io:format("h ~p t ~p ~n",[Head,Tail]),

  %loop
  partition_helper21(Tail, D, [Head|Result_lst]). % put the [Head] into Result_lst == [] ++ [[1,2]]


% partition with Head recursion
% part([1,2,3,4,5,6,7,8], 2) == [[1,2], [3,4], [5,6], [7,8]]
% part([1,2,3,4,5,6,7],2)    == [[1,2], [3,4], [5,6], [7]]

part(Lst, N) ->  n_chunks(Lst, N).

n_chunks([], _) -> [];
n_chunks(Lst,Len) when Len > length(Lst) -> [Lst];
n_chunks(Lst, Len) ->
  %{H=[1,2], T=[3,4]}
  {H,T} = lists:split(Len, Lst),
  [H| n_chunks(T, Len)].



%%
%%inse(L, E) -> insertion_helper(L, E, []).
%%
%%insertion_helper([], _, Result_lst)       -> Result_lst;
%%
%%insertion_helper(L=[H|T], E, Result_lst)  ->
%%  io:format("Result_lst: ~p~n", [Result_lst]),
%%  C = counter(E),
%%  io:format("C: ~p ~n", [C]),
%%  {Left, Right} = lists:split(C, L),
%%  io:format("Left: ~p, Right:~p~n", [Left, Right]),
%%  insertion_helper(T, C, Result_lst ++ [Left ++ [E|Right]]).
%%
%%


counter(0) -> 0;
counter(E) ->
  if
    E =< 10 -> E-1;
    true -> counter(E-1)
  end.


% ----------- inse ----------
%%inse([], _) -> [];
%%inse(L, N)  -> inse(L, N, [], []).
%%
%%inse([], N, B, Result) -> Result++[B++[N]];
%%inse(L=[H|T], N, B, Result) -> inse(T, N, B ++[H], Result++[B++[N]++L]).


inse(L, V) -> inser(L, V, []).
inser([],V, Acc) -> [Acc++[V]];
inser(L=[H|T],V, Acc) -> [Acc ++ [V|L] ] ++ inser(T,V,Acc++[H]).



% ----------- perms ----------
perms([]) -> [[]];
perms(L)  -> [[H|T] || H <- L, T <- perms(L -- [H])].

cval(_V, [])    -> 0;
cval(V, [V|T])  -> 1 + cval(V, T);
cval(_V, [H|T]) -> cval(_V, T).


