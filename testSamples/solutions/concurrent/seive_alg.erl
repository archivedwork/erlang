-module(seive_alg).
-compile(export_all).


start() ->
  Self = self(),
  Pid = fun() -> spawn(?MODULE, loop, []) end,
  lists:foreach(Pid, lists:seq(1,10)).
  %register(main, Pid).


loop() ->
  receive
    {next, Result} ->
      Result,
      loop();

    {ends, Tail} ->
      Tail,
      ok
  end.