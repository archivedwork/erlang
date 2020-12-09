-module(ret).
-compile(export_all).

decreaser([H|T])  -> T;
decreaser(N) -> N - 1;
decreaser([H|[]]) -> {the_end, [H]};
decreaser(1) -> {the_end, 1}.


% decreaser(N) ->
%     case N of 
%         0 -> {the_end, N+1}
%     end.


funfact(F,E,D) -> 
    spawn(?MODULE, funfact, [F,E,D,self()]),
    receive
        Result ->
            Result
    after 1000 -> ok
    end.



funfact(F, {the_end, El},_D, PreviousPid) -> PreviousPid ! F(El);






funfact(F,El,D,PreviousPid) ->
        Result = F(El),
        NPid = spawn(?MODULE, funfact, [F, D(El), D, self()]),
        receive 
            NResult -> 
                 PreviousPid ! Result * NResult
        end.