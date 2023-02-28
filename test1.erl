-module(test1).
-export([start/1, proc/4]).


start(Sysproc) ->
    process_flag(trap_exit, Sysproc),
    io:format("Shell Pid: ~p~n", [self()]),
    PidA = spawn_link(test1, proc, [self(), a, true, fun() -> okA end]),
    PidB = spawn_link(test1, proc, [self(), b, true, fun() -> exit(kill) end]),
    PidC = spawn_link(test1, proc, [self(), a, true, fun() -> okC end]),
    PidD = spawn_link(test1, proc, [self(), a, true, fun() -> okD end]),
    PidE = spawn_link(test1, proc, [self(), a, true, fun() -> okE end]),

    io:format("ProcA: ~p~nProcB: ~p~n", [PidA, PidB]).
    %exit (PidB, kill).

proc(Shell, Tag, Sysproc, F) ->
    process_flag(trap_exit, Sysproc),
    F(),
    receive
        Msg ->
                io:format("Proc ~p get msg: ~p~n", [Tag, Msg])
        after 65000 ->
            Shell ! {hello_from, Tag, self()}
        end.