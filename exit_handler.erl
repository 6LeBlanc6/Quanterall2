-module(exit_handler).
-export([on_exit/2]).

on_exit(Pid, F) ->
    _MyMon = spawn(fun() ->
                            process_flag(trap_exit, true),
                            link(Pid),
                            receive
                                {'EXIT', Pid, Reason} -> F(Reason)
                                end
                            end). 