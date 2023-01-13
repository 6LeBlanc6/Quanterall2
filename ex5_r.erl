-module(ex5_r).
-export([loop/1, start/1]).
%State = {N, Parent}
%P0 -> P1(P0) -> P(P1) ....P5(P4)

start(N) ->
    _PN = spawn (ex5_r, loop, [{N, self()}]).


loop({5, _}) -> done;

loop(State) ->
    receive
        {create_child} -> {N, Parent} = State,
                                Child = spawn(ex5_r, loop, [{N+1, self()}]),
                                io:format("N: ~p, Parent: ~p, Me: ~p, Child:~p~n", [N, Parent, self(), Child]),
                                Child ! {create_child},
                                NewState = State;
        {do, {calc, X}} -> {N, Parent} = State,
                            S = X*X,
                            io:format("N:~p, S:~p~n", [N, S]),
                            Parent ! {do, {calc, X}},
                        NewState = State;
        Any -> io:format("Any: ~p~n", [Any]),
                NewState = State
        end,
    loop(NewState).