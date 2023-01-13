-module(ex4).

-export([loop/1, start/1, client/2]).

start(N) ->
        spawn(ex4, loop, [{N, []}]).

%P1 -> P2 -> P3 -> .... PN

%N = 5

% State = {Child}

loop({5, _}) -> ok;

loop(State) ->
    
 {N, _} = State,
    Child = spawn(ex4, loop, [N +1, []])
        io:format("N: ~p, Child: ~p~n", Child [Any]),
            Any -> Any

    loop(NewState).

client(Server, Request) ->
    Server ! {self(), Request},
    receive
        {Server, Response}