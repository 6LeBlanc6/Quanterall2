-module(ex3).
-export([loop/1, start/1, client/2]).

start(Arg) ->
    spawn(ex3, loop, [Arg]).

%state = {}

loop(State) ->
    receive
        {Client,  {rectangle, X, Y}} -> S = X*Y,
            %io:format("S = ~p~n", [S]),
            Client ! {self(), {response, S}},
                NewState = State;
        {Client, {square, A, B}} -> F = A*B,
            Client ! {self(), {response, F}},
                NewState = State;
        {Client, {triangle, D, E}} -> L = D*E/2,
            Client ! {self(), {response, L}},
                NewState = State;
        {Client, {circle, R}} -> M = 3.14*R*R,
            Client ! {self(), {response, M}},
                NewState = State;
    Any -> Any,
        NewState = State
    end,
    loop(NewState).

 client(Server, Request) ->
    Server ! {self(), Request},
    receive
        {Server, Response} -> Response
        end.