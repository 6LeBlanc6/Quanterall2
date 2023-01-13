-module(ex5).
-export([loop/1, start/2]).


%State = {N, Parent}   tova shte e za domashno da se kombinirat ->, Child}
%P1 -> P2 -> P3 .... PN
%PN ->
%P5 -> P4(P5) -> P3(P4) ->

start(N, X) ->
    PN = spawn(ex5, loop, [{N, self()}]),
    PN ! {create_child},
    receive
            {last_alive, LastAlive} -> LastAlive ! {do, {calc, X}};
            Any -> io:format("Any: ~p~n", [Any])
        end.

loop({0, Parent}) -> Parent ! {last_alive, Parent};

loop(State) ->
    receive
        {create_child} -> {N, Parent} = State,
                       Child = spawn(ex5, loop, [{N-1, self()}]),
                       io:format("N: ~p, Parent: ~p, Me: ~p, Child: ~p~n", [N, Parent, self(), Child]),
                       Child ! {create_child},
                       NewState = State;
        {do, {calc, X}} -> {N, Parent} = State,
                                S = X*X,
                                io:format("N: ~p, S:~p~n", [N, S]),
                                Parent ! {do, {calc, S}},
                                NewState = State;
        {last_alive, LastAlive} -> {_N, Parent} = State,
                                   Parent ! {last_alive, LastAlive},
                                   NewState = State; 
        Any -> io:format("Any: ~p~n", [Any]),
        NewState = State
        end,
    loop(NewState).

%factoriel(0) -> 1;
%N*factoriel(N-1).


