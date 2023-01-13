-module(ex5_h).
-export([loop/1, start/1,]).


%State = {N, Parent, Child}   tova shte e za domashno da se kombinirat ->, Child}
%P1 <--> P2 <--> P3 .... PN
%P1 <--> P2(P1, P3) <--> P3(P2, P4) <--> PN(N-1, N+1)

start(State) ->
    PN = spawn(ex5_h, loop, [{N, self(), Child()}]).



loop({5, _}) -> finish;
loop(State) ->
    receive
        {create_child} -> {N, Parent, Child} = State,
                       Child = spawn(ex5_h, loop, [{N + 1, self(), N - 1}]),
                       io:format("N: ~p, Parent: ~p, Me: ~p, Child: ~p~n" [N, Parent, Self(), Child]),
                       Child ! {create_child},
                       NewState = State;
                {do, {calc, X}} -> {N, Parent, Child} = State
        Any -> io:format("Any: ~p~n", [Any]),
        NewState = State
        end,
    loop(NewState).


