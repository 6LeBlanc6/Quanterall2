-module(bc).
-export([loop/1, start/0]).

start() ->
    _P = spawn(bc, loop, [0]),
    _C = State.
%State = {0}

loop(State) ->   
    receive
        {"B", _Y, _Z} -> NewState = {State + 1},
        io:format("NewState: ~p ~n", [NewState]);
        {_X, _Y, _Z} -> State,
        io:format("State: ~p ~n", [State]);
               % C = {State + 1},
                
   % case _X of
    %    'b' -> NewState = {C + 1},
     %                   io:format("NewState: ~p ~n", [NewState]);
        Any ->
                        io:format("Any: ~p ~n", [Any]),
        NewState = State,
                        io:format("NewState: ~p ~n", [State])
       % end
    end,
loop(NewState).