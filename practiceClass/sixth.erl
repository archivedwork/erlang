-module(sixth).
-compile(export_all).

eval() ->
	try
		{ok, Mod} = io:read("Module name: "),
		Exported = Mod:module_info(exports),
		{ok, Fun} = io:read("Function name: "),
		{Fun, Arity} = lists:keyfind(Fun, 1, Exported),
		Arguments =
			lists:map(fun(_) ->
						{ok, Arg} = io:read("Give me arguments: "),
						Arg
					  end, lists:seq(1, Arity)),
		%Mod:Fun(Arguments)
		%Mod:Fun(lists:nth(1, Arguments), lists:nth(2, Arguments))
		{Mod, Fun, Arguments}
	of
		{M, F, A} -> catch apply(M, F, A)
	catch
		error:{badmatch, false} -> "Function does not exist";
		_:{badmatch, _} -> "Bad term";
		_:undef -> "Module does not exist";
		_:badarg -> "Not an atom as a module name"
	end.

read(0) -> 
	[];
read(N) ->
	{ok, Arg} = io:read("Give me arguments: "),
	[Arg | read(N-1)].

eval_try(Fun) ->
	try Fun([])
	of
		Val -> {result, Val}
	catch
	    Class:Type -> {Class, Type}
	end.

eval_fun(Fun) ->
	case catch Fun([]) of
		{'EXIT', Error} -> {error, Error};
		Val -> {result, Val}
	end.

error_fun(Arg) ->
	{'EXIT', Arg}.