-module(ex4).

-export([loop/1, start/1, client/2]).

start(N) ->
        spawn(ex4, loop, [{N, []}]).

%P1 -> P2 -> P3 -> .... PN

%N = 5

% State = {Child}

loop(State) ->
    case
       P1 -> {N, _} = State,
       P2 = spawn(ex4, loop, [1]),
       io:format("N: ~p, P2: ~p~n", [N, P2]),

       P2 -> {N, _} = State,
       P3 = spawn(ex4, loop, [2]),
       io:format("N: ~p, P3: ~p~n", [N, P3]),
       
       P3 -> {N, _} = State,
       P4 = spawn(ex4, loop, [3]),
       io:format("N: ~p, P5: ~p~n", [N, P4]),

       P4 -> {N, _} = State,
       P5 = spawn(ex4, loop, [4]),
       io:format("N: ~p, P5: ~p~n", [N, P5]),

       P5 -> {N, _} = State,
        io:format("Any: ~p ~n", [Any]),
            Any -> Any
        end,
    loop(NewState).

client(Server, Request) ->
    Server ! {self(), Request},
    receive
        {Server, Response}