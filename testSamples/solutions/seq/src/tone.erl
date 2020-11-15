%%%-------------------------------------------------------------------
%%% @author mo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Oct 2020 21:01
%%%-------------------------------------------------------------------
-module(tone).
-author("mo").

%% API
%% -export([]).
-compile(export_all).



% -----------------------  anagram / perm ----------------










% ---------------------- every_other  --------------------
% not working
every_other(F, G, Lst) -> every_other(F, G, Lst, [], 2).

every_other(_, _, [], ResultLst, 0)           -> ResultLst,
io:format("ResultLst: ~p~n", [ResultLst]);
every_other(F, G, [H1,H2|T], ResultLst, Counter)    -> every_other(F, G, T, ResultLst ++ [F(H1)] ++[G(H2)] , Counter-1),
%%  case is_even(H) of
%%    true   ->   every_other(F, G, T, ResultLst ++ [F(H)] , Counter-1);
%%    false  ->   every_other(F, G, T, ResultLst ++ [G(H)], Counter-1)
%%  end,
io:format("Counter: ~p~n", [Counter]).


is_even(N) when N rem 2 == 0 -> true;
is_even(_)                   -> false.
% ---------------------- farfallino ----------------------

%% ----------- farfalino task ------------

is_vowel(C) ->
  case C of
    $a  -> true;
    $e  -> true;
    $i  -> true;
    $o  -> true;
    $u  -> true;
    _   -> false
  end.


farfallino(Str) -> farfa_helper(Str, [], length(Str)).

farfa_helper([], ResultLst, 0) -> ResultLst;
farfa_helper([H|T], ResultLst, Counter) ->
  case is_vowel(H) of
    true  -> farfa_helper(T, ResultLst ++ [H] ++ "f" ++ [H], Counter-1);
    false ->
      farfa_helper(T, ResultLst ++ [H] , Counter-1)
  end.


% ---------------------- armstrong -----------------------
% N = 9, length(N) ==1, so 9^1 = 9 is armstrong
% N=10, length(10) == 1^2 + 0^2
% length(number) is not proper things to do so, change integer to string and take length of it


% count in numbers is N rem 10
% count in lists   is length(N)

% cut the number into  list of n size, eg.12 = [1,2]
digits(0, Acc) -> Acc;
digits(Num, Acc) ->
  digits( Num div 10, [Num rem 10 | Acc]).

len([])          -> 0;
len([_|T])       -> 1 + len(T).

count_and_digits(Num) ->
  Digits = digits(Num,[]),
  Count  = len(Digits),
  {Count, Digits}.

armstrong(Num) ->
  {Count, Digits} =  count_and_digits(Num),
  Num == lists:foldl(fun(X, Sum) -> Sum + math:pow(X, Count) end, 0, Digits).
