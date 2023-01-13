-module(test1).
-export([start/1, proc/4]).

start(Sysproc) ->
process_flag(trap_exit, Sysproc),
io:format("Shell Pid: ~p~n", [self()]),
PidA = spawn_link(test1, proc, [self(), a, false, fun() -> ok end]),
start2() -> 
    PidB = spawn_link(test1, proc, [self(), b, true, fun() -> exit(kill) end]),
    PidB1 = spawn_link(test1, proc, [PidB, b1, false, fun() -> PidB ! {"I am fine_B1"} end]),
    PidB2 = spawn_link(test1, proc, [PidB, b2, false, fun() -> PidB ! {"I am fine_B2"} end]),
io:format("ProcA: ~p~nProcB: ~p~n", [PidA, PidB]).

%exit(PidB, kill). 

proc(Shell, Tag, Sysproc, F) ->
process_flag(trap_exit, Sysproc),
F(),
receive
Msg ->
io:format("Proc ~p get msg: ~p.~n", [Tag, Msg])
after 15000 ->
Shell ! {hello_from, Tag, self()}
end.