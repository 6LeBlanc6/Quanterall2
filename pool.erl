-module(pool).
-export([loop/1, loop_s/1, start/2]).


%S -> W1, W2,...Wn

start(N, F) ->
                Supervisor = spawn(pool, loop_s, [{[]}]),
                Supervisor ! {start_pool, N, F}.


%State = {[W1, W2 ...Wn]}
loop_s(State) ->
            receive
                {start_pool, N, F} ->
                                process_flag(trap_exit, true),
                             Pool = [spawn_link(pool, loop, [{I, F}]) || I <- lists:seq(1,N)],
                             io:format("Pool: ~p~n", [Pool]),
                             NewState = {Pool};
                {'EXIT', _Pid, Reason} -> {I, F} = Reason,
                                                NewProcess = spawn_link(pool, loop, [{I, F}]),
                                                io:format("Process with ID ~p restarted, New Pid:~p ~n", [I, NewProcess]),
                                            
                                                NewState = State;
                Any -> io:format("Any: ~p~n", [Any]),
                NewState = State
                end,
loop_s(NewState).
%State = {I, F}
loop(State) ->
    receive
        {X} ->  {I, F} = State,
                M = F(X),
                io:format("I: ~p, M: ~p~n", [I, M]);
        exit ->  {I, F} = State,
                    exit({I, F});
        Any -> io:format("Any: ~p~n", [Any])
    end,
    NewState = State,
    loop(NewState).