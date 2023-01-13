-module(ex5).
-export([loop/1, start/1, factoriel/1]).


%State = {N, Parent}   tova shte e za domashno da se kombinirat ->, Child}
%P1 -> P2 -> P3 .... PN
%PN ->
%P5 -> P4(P5) -> P3(P4) ->

start(State) ->
    PN = spawn(ex5, loop, [{N, self()}]).

loop({0, _}) -> done;
loop(State) ->
    receive
        {create_child} -> {N, Parent} = State,
                       _Child = spawn(ex5, loop, [{N -1, self()}]),
                       io:format("N: ~p, Parent: ~p, Me: ~p, Child: ~p~n" [N, Parent, Self(), Child]),
                       Child ! {create_child},
                       NewState = State;
                {do, {calc, X}} -> {N, Parent} = State
        Any -> io:format("Any: ~p~n", [Any]),
        NewState = State
        end,
    loop(NewState).

factoriel(0) -> 1;
N*factoriel(N-1).


