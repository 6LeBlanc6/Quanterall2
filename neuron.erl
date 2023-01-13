-module(neuron).
-export([start/1, loop/1]).

start(0) ->
    State0 = {[{0, test}, {0, alabala}, {0, []}]},
    spawn(neuron, loop, [State0]).

%State = {[{C1, Pt1}, {C2, Pt2}, {C3, Pt3}]}

loop(State) ->
        {[{C1, test}, {C2, alabala}, {C3, []}]} = State,
    receive
        test -> {L} = State,
                case lists:keyfind(test, 2, L) of
                    {C1, test} -> NewState = {[{C1 + 1, test}, {C2, alabala}, {C3, []}]},
                                io:format("NewState: ~p~n", [NewState]);

                        false -> NewState = State
                end;
        alabala -> {L} = State,
                case lists:keyfind(alabala, 2, L) of
                    {C2, alabala} -> NewState = {[{C1, test}, {C2 + 1, alabala}, {C3, []}]},
                                io:format("NewState: ~p~n", [NewState]);
                        false -> NewState = State
                end;

        [] -> {L} = State,
                case lists:keyfind([], 2, L) of
                    {C3, []} -> NewState = {[{C1, test}, {C2, alabala}, {C3 + 1, []}]},
                                io:format("NewState: ~p~n", [NewState]);

                        false -> NewState = State
                end;

        Any -> NewState = State,
                 io:format("Any: ~p~n", [Any])
    end,
        loop(NewState).