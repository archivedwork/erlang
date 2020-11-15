-module(sec).
%-export([f/0, f/1, boo/1, triangle/3]).
-compile(export_all).
%newf(A,B,_D)->
%C=A+B,
%C*2.

tri(_L1,_L1,L1) when is_integer(L1)-> equilateral;
tri(L1,L2,L3) when (L1==L2) or (L1==L3) or (L2==L3)-> iso;
%tri(L1,L2,L3) when triangle(L1,L2,L3)==iso -> iso; % illegal guard
tri(_,_,_)-> scalenus.

%fout(A,B,C)-> %%% check them in fancy way
%				f(A,B,C).

%%%%

triangle(_L1,_L1,_L1)  -> equilateral;
triangle(_L1,_L1,_)-> iso;
triangle(_,_L1,_L1)-> iso;
triangle(_L1,_,_L1)-> iso;
triangle(_L1,_L2,_L3)-> scalenus.

%duplicates(_V1,_V2)-> different.


f()-> 
%2+3,
{ok,whatever,ciao}.

f(A)-> fine.

%f1(B)-> B;
%f1(4)-> omg.

boo(0)-> "booh!";
boo(1)-> ok;
%%% [1| []]
boo([H|_T])-> [H];
boo(A)-> A*3.

hi(_,0)->ok;
hi(Name,C) when is_number(C)-> 
  %'hi'.
io:format("Hi ~p~p ~n",[Name,Name]),
hi(Name,C-1).

print(E)->
 A=io:format("Element is ~p~n",[E]),
 B=io:format("Element is ~s~n",[E]), %%only strings
 {A,B}.

%%%%%%%%%%%%%55

% Erlang/OTP 22 [erts-10.5] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]

% Eshell V10.5  (abort with ^G)
% 1> pwd().
% c:/Program Files/erl10.5/usr
% ok
% 2> cd("C:/Users/eannrea/Desktop").
% c:/Users/eannrea/Desktop
% ok
% 3> c(sec).
% sec.erl:5: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
% sec.erl:8: Warning: function boo/0 is unused
% {ok,sec}
% 4> c(sec).
% sec.erl:5: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
% sec.erl:8: Warning: variable 'A' is unused
% {ok,sec}
% 5> c(sec).
% {ok,sec}
% 6> sec:f().
% ok
% 7> sec:boo().
% ** exception error: undefined function sec:boo/0
% 8> sec:boo(11).
% 33
% 9> c(sec).     
% {ok,sec}
% 10> sec:boo(0). 
% "booh!"
% 11> sec:boo(11).
% 33
% 12> c(sec).     
% sec.erl:8: Warning: function f1/1 is unused
% sec.erl:9: Warning: this clause cannot match because a previous clause at line 8 always matches
% {ok,sec}
% 13> sec:boo("whatever").
% ** exception error: an error occurred when evaluating an arithmetic expression
%      in operator  */2
%         called as "whatever" * 3
%      in call from sec:boo/1 (sec.erl, line 12)
% 14> c(sec).             
% sec.erl:8: Warning: function f1/1 is unused
% sec.erl:9: Warning: this clause cannot match because a previous clause at line 8 always matches
% sec.erl:15: Warning: variable 'T' is unused
% {ok,sec}
% 15> c(sec).
% sec.erl:9: Warning: this clause cannot match because a previous clause at line 8 always matches
% sec.erl:15: Warning: variable 'T' is unused
% {ok,sec}
% 16> sec:boo("whatever").
% 119
% 17> sec:boo("whatever") == $w
% 17> .
% true
% 18> $t.
% 116
% 19> "t"==['t'].
% false
% 20> "t"==[$t]. 
% true
% 21> '12334FRga'.
% '12334FRga'
% 22> [116].
% "t"
% 23> c(sec).                  
% sec.erl:9: Warning: this clause cannot match because a previous clause at line 8 always matches
% sec.erl:15: Warning: variable 'T' is unused
% {ok,sec}
% 24> sec:boo("whatever").     
% "w"
% 25> c(sec).             
% sec.erl:2: function f1/1 undefined
% sec.erl:4: Warning: function newf/3 is unused
% sec.erl:8: Warning: function sum/3 is unused
% sec.erl:10: Warning: function triangle/3 is unused
% sec.erl:14: Warning: variable 'L1' is unused
% sec.erl:14: Warning: variable 'L2' is unused
% sec.erl:14: Warning: variable 'L3' is unused
% sec.erl:16: Warning: function duplicates/2 is unused
% sec.erl:16: Warning: variable 'V1' is unused
% sec.erl:29: Warning: variable 'T' is unused
% error
% 26> c(sec).
% sec.erl:2: function f1/1 undefined
% sec.erl:4: Warning: function newf/3 is unused
% sec.erl:8: Warning: function sum/3 is unused
% sec.erl:10: Warning: function triangle/3 is unused
% sec.erl:16: Warning: function duplicates/2 is unused
% sec.erl:16: Warning: variable 'V1' is unused
% sec.erl:29: Warning: variable 'T' is unused
% error
% 27> c(sec).
% sec.erl:2: function f1/1 undefined
% sec.erl:4: Warning: function newf/3 is unused
% sec.erl:8: Warning: function sum/3 is unused
% sec.erl:16: Warning: function duplicates/2 is unused
% sec.erl:29: Warning: variable 'T' is unused
% error
% 28> sec:triangle(1,1,1).
% ** exception error: undefined function sec:triangle/3
% 29> c(sec).             
% sec.erl:2: function f1/1 undefined
% sec.erl:4: Warning: function newf/3 is unused
% sec.erl:8: Warning: function sum/3 is unused
% sec.erl:16: Warning: function duplicates/2 is unused
% sec.erl:29: Warning: variable 'T' is unused
% error
% 30> c(sec).
% sec.erl:2: function f1/1 undefined
% sec.erl:28: Warning: variable 'T' is unused
% error
% 31> c(sec).
% sec.erl:28: Warning: variable 'T' is unused
% {ok,sec}
% 32> sec:triangle(1,1,1).
% equilateral
% 33> sec:triangle(1,2,1).
% iso
% 34> sec:triangle(1,2,3).
% scalenus
% 35> c(sec).             
% sec.erl:28: Warning: variable 'T' is unused
% {ok,sec}
% 36> sec:triangle(1,2,3).
% scalenus
% 37> c(sec).             
% sec.erl:10: Warning: this clause cannot match because a previous clause at line 9 always matches
% sec.erl:11: Warning: this clause cannot match because a previous clause at line 9 always matches
% sec.erl:12: Warning: this clause cannot match because a previous clause at line 9 always matches
% sec.erl:13: Warning: this clause cannot match because a previous clause at line 9 always matches
% sec.erl:28: Warning: variable 'T' is unused
% {ok,sec}
% 38> c(sec).             
% sec.erl:10: Warning: this clause cannot match because a previous clause at line 9 always matches
% sec.erl:11: Warning: this clause cannot match because a previous clause at line 9 always matches
% sec.erl:12: Warning: this clause cannot match because a previous clause at line 9 always matches
% sec.erl:13: Warning: this clause cannot match because a previous clause at line 9 always matches
% sec.erl:28: Warning: variable 'T' is unused
% {ok,sec}
% 39> c(sec).
% sec.erl:29: Warning: variable 'T' is unused
% {ok,sec}
% 40> sec:triangle(1,2,3).
% scalenus
% 41> sec:triangle(1,1,1).
% equilateral
% 42> c(sec).             
% sec.erl:9: syntax error before: L1
% sec.erl:3: Warning: export_all flag enabled - all functions will be exported
% sec.erl:27: Warning: variable 'A' is unused
% sec.erl:35: Warning: variable 'T' is unused
% error
% 43> c(sec).
% sec.erl:3: Warning: export_all flag enabled - all functions will be exported
% sec.erl:27: Warning: variable 'A' is unused
% sec.erl:35: Warning: variable 'T' is unused
% {ok,sec}
% 44> sec:tri(1,2,1).     
% iso
% 45> sec:tri(2,2,1).
% iso
% 46> sec:tri(2,2,2).
% equilateral
% 47> c(sec).        
% sec.erl:10: call to local/imported function triangle/3 is illegal in guard
% sec.erl:3: Warning: export_all flag enabled - all functions will be exported
% sec.erl:28: Warning: variable 'A' is unused
% sec.erl:36: Warning: variable 'T' is unused
% error
% 48> hd([1,2,3]).
% 1
% 49> erlang:hd([1,2]).
% 1
% 50> [A|T]= [1,2].
% [1,2]
% 51> A.
% 1
% 52> element(1,[1,2]).
% ** exception error: bad argument
%      in function  element/2
%         called as element(1,[1,2])
% 53> element([1,2],1).
% ** exception error: bad argument
%      in function  element/2
%         called as element([1,2],1)
% 54> element(1, {2,3}).
% 2
% 55> element(1, [2,3]).
% ** exception error: bad argument
%      in function  element/2
%         called as element(1,[2,3])
% 56> setelement(1, {2,3}, hello).
% {hello,3}
% 57> A={1,2}.
% ** exception error: no match of right hand side value {1,2}
% 58> f(A).   
% ok
% 59> A={1,2}.
% {1,2}
% 60> setelement(1, A, hello).    
% {hello,2}
% 61> A.
% {1,2}
% 62> P= setelement(1, A, hello).
% {hello,2}
% 63> P.
% {hello,2}
% 64> f().    
% ok
% 65> P.
% * 1: variable 'P' is unbound
% 66> size({1,2,3}).
% 3
% 67> size([1,2,3]).
% ** exception error: bad argument
%      in function  size/1
%         called as size([1,2,3])
% 68> lenght([1,2]).
% ** exception error: undefined shell command lenght/1
% 69> length([1,2]).
% 2
% 70> list_to_tuple([1,2]).
% {1,2}
% 71> integer_to_list(12). 
% "12"
% 72> integer_to_list(12)++"hi".
% "12hi"
% 73> help(lists).
% ** exception error: undefined shell command help/1
% 74> help().     
% ** shell internal commands **
% b()        -- display all variable bindings
% e(N)       -- repeat the expression in query <N>
% f()        -- forget all variable bindings
% f(X)       -- forget the binding of variable X
% h()        -- history
% history(N) -- set how many previous commands to keep
% results(N) -- set how many previous command results to keep
% catch_exception(B) -- how exceptions are handled
% v(N)       -- use the value of query <N>
% rd(R,D)    -- define a record
% rf()       -- remove all record information
% rf(R)      -- remove record information about R
% rl()       -- display all record information
% rl(R)      -- display record information about R
% rp(Term)   -- display Term using the shell's record information
% rr(File)   -- read record information from File (wildcards allowed)
% rr(F,R)    -- read selected record information from file(s)
% rr(F,R,O)  -- read selected record information with options
% ** commands in module c **
% bt(Pid)    -- stack backtrace for a process
% c(Mod)     -- compile and load module or file <Mod>
% cd(Dir)    -- change working directory
% flush()    -- flush any messages sent to the shell
% help()     -- help info
% i()        -- information about the system
% ni()       -- information about the networked system
% i(X,Y,Z)   -- information about pid <X,Y,Z>
% l(Module)  -- load or reload module
% lm()       -- load all modified modules
% lc([File]) -- compile a list of Erlang modules
% ls()       -- list files in the current directory
% ls(Dir)    -- list files in directory <Dir>
% m()        -- which modules are loaded
% m(Mod)     -- information about module <Mod>
% mm()       -- list all modified modules
% memory()   -- memory allocation information
% memory(T)  -- memory allocation information of type <T>
% nc(File)   -- compile and load code in <File> on all nodes
% nl(Module) -- load module on all nodes
% pid(X,Y,Z) -- convert X,Y,Z to a Pid
% pwd()      -- print working directory
% q()        -- quit - shorthand for init:stop()
% regs()     -- information about registered processes
% nregs()    -- information about all registered processes
% uptime()   -- print node uptime
% xm(M)      -- cross reference check a module
% y(File)    -- generate a Yecc parser
% ** commands in module i (interpreter interface) **
% ih()       -- print help for the i module
% true
% 75> ih(lists)
% 75> .
% ** exception error: undefined shell command ih/1
% 76> lists:ih().
% ** exception error: undefined function lists:ih/0
% 77> ih().      
% iv()         -- print the current version of the interpreter
% im()         -- pop up a monitor window
% ii(Mod)      -- interpret Mod(s) (or AbsMod(s))
% ii(Mod,Op)   -- interpret Mod(s) (or AbsMod(s))
%                 use Op as options (same as for compile)
% iq(Mod)      -- do not interpret Mod(s)
% ini(Mod)     -- ii/1 at all Erlang nodes
% ini(Mod,Op)  -- ii/2 at all Erlang nodes
% inq(Mod)     -- iq at all Erlang nodes
% ib(Mod,Line) -- set a break point at Line in Mod
% ib(M,F,Arity)-- set a break point in M:F/Arity
% ibd(Mod,Line)-- disable the break point at Line in Mod
% ibe(Mod,Line)-- enable the break point at Line in Mod
% iba(M,L,Action)-- set a new action at break
% ibc(M,L,Action)-- set a new condition for break
% ir(Mod,Line) -- remove the break point at Line in Mod
% ir(M,F,Arity)-- remove the break point in M:F/Arity
% ir(Mod)      -- remove all break points in Mod
% ir()         -- remove all existing break points
% il()         -- list all interpreted modules
% ip()         -- print status of all interpreted processes
% ic()         -- remove all terminated interpreted processes
% ipb()        -- list all break points
% ipb(Mod)     -- list all break points in Mod
% ia(Pid)      -- attach to Pid
% ia(X,Y,Z)    -- attach to pid(X,Y,Z)
% ia(Pid,Fun)  -- use own Fun = {M,F} as attach application
% ia(X,Y,Z,Fun)-- use own Fun = {M,F} as attach application
% iaa([Flag])  -- set automatic attach to process
%                 Flag is init,break and exit
% iaa([Fl],Fun)-- use own Fun = {M,F} as attach application
% ist(Flag)    -- set stack trace flag
%                 Flag is all (true),no_tail or false
% ok
% 78> ii(lists).
% ** Cannot interpret stdlib module: lists
% error
% 79> lists:help()
% 79> .
% ** exception error: undefined function lists:help/0
% 80> lists:help().
% ** exception error: undefined function lists:help/0
% 81> h(lists).
% ** exception error: undefined shell command h/1
% 82> lists:h().
% ** exception error: undefined function lists:h/0
% 83> c(sec).      
% sec.erl:3: Warning: export_all flag enabled - all functions will be exported
% sec.erl:31: Warning: variable 'A' is unused
% sec.erl:39: Warning: variable 'T' is unused
% {ok,sec}
% 84> sec:hi("Me",3).
% Hi "Me"
% Hi "Me"
% Hi "Me"
% ok
% 85> sec:hi(Me,3).  
% * 1: variable 'Me' is unbound
% 86> sec:hi(me,3).
% Hi me
% Hi me
% Hi me
% ok
% 87> io:format("text").
% textok
% 88> io:format("text~n").
% text
% ok
% 89> io:format("text\n").
% text
% ok
% 90> io:format("text ~s ~d",["string",12]).
% ** exception error: bad argument
%      in function  io:format/3
%         called as io:format(<0.63.0>,"text ~s ~d",["string",12])
% 91> io:format("text ~s ~p",["string",12]).
% text string 12ok
% 92> io:format("text ~s ~p~n",["string",12]).
% text string 12
% ok
% 93> io:format("text ~s ~p~n","string").     
% ** exception error: bad argument
%      in function  io:format/3
%         called as io:format(<0.63.0>,"text ~s ~p~n","string")
% 94> D=[1].                             
% [1]
% 95> io:format("text ~p~n",D).          
% text 1
% ok
% 96> R=[1,2,3].               
% [1,2,3]
% 97> io:format("text ~p~n",R).
% ** exception error: bad argument
%      in function  io:format/3
%         called as io:format(<0.63.0>,"text ~p~n",[1,2,3])
% 98> io:format("text ~p~n",[R]).
% text [1,2,3]
% ok
% 99> c(sec).                    
% sec.erl:3: Warning: export_all flag enabled - all functions will be exported
% sec.erl:31: Warning: variable 'A' is unused
% {ok,sec}
% 100> sec:print(ciao).
% ** exception error: bad argument
%      in function  io:format/3
%         called as io:format(<0.63.0>,"Element is ~p~n",ciao)
%      in call from sec:print/1 (sec.erl, line 49)
% 101> c(sec).         
% sec.erl:3: Warning: export_all flag enabled - all functions will be exported
% sec.erl:31: Warning: variable 'A' is unused
% {ok,sec}
% 102> sec:print(ciao).
% Element is ciao
% printedAll
% 103> sec:print("hello man").
% Element is "hello man"
% printedAll
% 104> sec:print(123).        
% Element is 123
% printedAll
% 105> sec:print(123.3).
% Element is 123.3
% printedAll
% 106> c(sec).                
% sec.erl:3: Warning: export_all flag enabled - all functions will be exported
% sec.erl:31: Warning: variable 'A' is unused
% {ok,sec}
% 107> sec:print(123.3).
% Element is 123.3
% ** exception error: bad argument
%      in function  io:format/3
%         called as io:format(<0.63.0>,"Element is ~s~n",[123.3])
%      in call from sec:print/1 (sec.erl, line 50)
% 108> sec:print("hi"). 
% Element is "hi"
% Element is hi
% {ok,ok}
% 109> c(sec).          
% sec.erl:3: Warning: export_all flag enabled - all functions will be exported
% sec.erl:31: Warning: variable 'A' is unused
% {ok,sec}
% 110> sec:totuple([1,2,3]).
% 1
% 111> i(lists).            
% ** exception error: undefined shell command i/1
% 112> lists:module_info().
% [{module,lists},
%  {exports,[{append,2},
%            {append,1},
%            {subtract,2},
%            {reverse,1},
%            {nth,2},
%            {nthtail,2},
%            {prefix,2},
%            {suffix,2},
%            {droplast,1},
%            {last,1},
%            {seq,2},
%            {seq,3},
%            {sum,1},
%            {duplicate,2},
%            {min,1},
%            {max,1},
%            {sublist,3},
%            {sublist,2},
%            {delete,2},
%            {zip,2},
%            {unzip,1},
%            {zip3,3},
%            {unzip3,1},
%            {zipwith,...},
%            {...}|...]},
%  {attributes,[{vsn,[248700276408140122475029922157878627785]},
%               {dialyzer,[{no_improper_lists,{ukeymergel,3}}]}]},
%  {compile,[{version,"7.4.4"},
%            {options,[debug_info,
%                      {d,'USE_ESOCK',true},
%                      {i,"/net/isildur/ldisk/daily_build/22_prebuild_opu_o.2019-09-17_11/otp_src_22/lib/stdlib/src/../include"},
%                      {i,"/net/isildur/ldisk/daily_build/22_prebuild_opu_o.2019-09-17_11/otp_src_22/lib/stdlib/src/../../kernel/include"}]},
%            {source,"/net/isildur/ldisk/daily_build/22_prebuild_opu_o.2019-09-17_11/otp_src_22/lib/stdlib/src/lists.erl"}]},
%  {md5,<<187,25,238,82,209,16,164,214,35,230,24,25,194,16,
%         205,201>>}]
 







