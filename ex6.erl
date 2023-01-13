-module(ex6).
-export([loop/1, start/2]).
%State = {N, Parent, [Child1, Child2, Child3]}
%P5 -> P4(Ch1, Ch2, Ch3) -> P3(...) ..... P0(..)
start(N, X) ->
    PN = spawn(ex6, loop, [{N, self(), []}]),
    PN ! {create_children},
    receive
        {last_alive, LastAlive} -> LastAlive ! {do, {calc, X}};
        Any -> io:format("Any: ~p~n", [Any])

    end.

loop({0, Parent, _Children}) -> Parent ! {last_alive, Parent};

loop(State) ->
    receive
        {create_children} -> {N, Parent, _Children} = State,
                       Child1 = spawn(ex6, loop, [{N-1, self(), []}]),
                       Child2 = spawn(ex6, loop, [{N-1, self(), []}]),
                       Child3 = spawn(ex6, loop, [{N-1, self(), []}]),

                       io:format("N: ~p, Parent: ~p, Me: ~p, Child1: ~p, Child2: ~p, Child3: ~p~n", [N, Parent, self(), Child1, Child2, Child3]),
                       Child1 ! {create_children},

                       NewState = {N, Parent, [Child1, Child2, Child3]};
               
        {do, {calc, X}} -> {N, Parent, [Child1, Child2, Child3]} = State,
                S=X*X,
                io:format("N: ~p, S: ~p~n", [N, S]),
                Parent ! {do, {calc, S}},
               
                %Child1 ! {do, {calc, S}},
                Child2 ! {do, {calc, S}},
                Child3 ! {do, {calc, S}},

                NewState = State;
                
        {last_alive, LastAlive} ->
                        {_N, Parent, _Children} = State,
                        Parent ! {last_alive, LastAlive},
                        NewState = State;

        Any -> io:format("Any: ~p~n", [Any]),
        NewState = State
        end,
    loop(NewState).




%start(State) ->
 %   PN = spawn(ex6, loop, [{N, self()}]).
