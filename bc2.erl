-module(bc2).
-export([loop/1, start/0]).

start() -> State = {0},
    _P = spawn(bc2, loop, [{State}]).

%State = {0}

loop(State) ->   
    receive
        
        {"B", Y, Z} -> {C} = State, 
        NewState = {C + 1};
                      %  io:format("NewState: ~p ~n", [NewState]);
        Any -> NewState = State
                       % io:format("Any: ~p ~n", [Any]),
    end,
    io:format("NewState: ~p ~n", [NewState]),
loop(NewState).