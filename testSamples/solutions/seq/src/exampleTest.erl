%%%-------------------------------------------------------------------
%%% @author mo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Oct 2020 1:40
%%%-------------------------------------------------------------------
-module(exampleTest).
-author("mo").

%% API
-compile(export_all).
%%
%%
%%For example, for the list `[1,0,1,0,1,0]` the output is the value `42`.
%%
%%The list `[1,0,1,0,1,0]` stands for $101010_2$, that is interpreted as $1*2^5 + 0*2^4  + 1*2^3 + 0*2^2 + 1*2^1 + 0*2^0 == 42$
%%
%%**IMPORTANT:** The usage of function `list_to_integer/2` is forbidden in the implementation!
%%
%%~~~
%%bin_to_decimal(list(0|1)) -> integer()
%%~~~
%%
%%Test cases:
%%-----------
%%
%%**Do not forget to change the name of the module!**
%%
%%~~~
%%test:bin_to_decimal([]) == 0
%%test:bin_to_decimal([0]) == 0
%%test:bin_to_decimal([0,0,0,0,0]) == 0
%%test:bin_to_decimal([1,0,0,0,0]) == 16
%%test:bin_to_decimal([1,0,1,0,1,0]) == 42
%%test:bin_to_decimal([1,1,1,1,1,1,1,1,1,0,1,0,0]) == 8180
%%~~~
%%


bin_to_decimal([0]) -> 0;
bin_to_decimal(Lst) -> bin_to_decimal_helper(Lst, 0, length(Lst), []).

bin_to_decimal_helper([], Result, 0, _VLst) -> Result;
bin_to_decimal_helper(Lst=[H|T], Result, Counter, VLst) ->
  Len = length(Lst),

  bin_to_decimal_helper(T, lists:sum(VLst), Counter-1, VLst ++ [math:pow(H * 2, Len-1)]),
  io:format("Result: ~p , Len: ~p~n", [VLst, Len]).



power(N) -> N * N.


find_anagrams(Subject, Candidates) ->
  SubjectNew=string:to_lower(Subject),
  [X||X<-Candidates,length(SubjectNew)==length(X) andalso string:to_lower(X)/=SubjectNew andalso lists:usort(string:to_lower(X))==lists:usort(SubjectNew)].



anagrams(Lst1, Lst2) -> anagrams_helper(Lst1, Lst2, []).


anagrams_helper(Lst1=[H1|T1], Lst2=[H2|T2], ResultLst) ->
  Key = string:to_lower(H1),
  io:format("Key= ~p~n", [Key]),
  if
    length(Key) == length(H2)
  end.




start() ->
    Fun = fun(K,V1) when is_list(K) -> V1*2 end,
    Map = #{"k1" => 1, "k2" => 2, "k3" => 3},
    maps:map(Fun,Map).