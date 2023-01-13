-module(neuron_mine).
-export([start/1, loop/1]).

%State = {{C1, Pt1}, {C2, Pt3}, {C3, Pt3}}

start() -> State = {{C1, Pt1}, {C2, Pt3}, {C3, Pt3}},
    spawn(neuron_mine, loop, [{State}]).

loop(State) ->
    receive
        {"Pt1", _Y, _Z} -> NewState = {{C1 + 1, Pt1}, _, _},
            io:format("New State: ~p~n", [NewState]);

        {_X, "Y", _Z} -> NewState = { _, {C2 + 1, Pt2}, _},
            io:format("New State: ~p~n", [NewState]);

        {_X, _Y, "Z"} -> NewState = { _, _, {C3 + 1, Pt3}},
            io:format("New State: ~p~n", [NewState]);


        Any -> NewState = State, 
            io:format("Any: ~p~n", [Any])
    end,


    loop(NewState).