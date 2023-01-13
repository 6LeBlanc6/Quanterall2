-module(ex3).
-export([loop/1, start/1, client/2]).

start(Arg) ->
    spawn(ex3, loop, [Arg]).

%state = {}

loop(State) ->
    receive
      {Client,  {rectangle, X, Y}} -> S = X*Y,
        %io:format("S = ~p~n", [S]),
        Client ! {response, S},
        NewState = State;

    Any -> Any,
        NewState = State
    end,
    loop(NewState).

client (Server, Request) ->
    Server ! {self(), Request},
    receive
        {Server, Response} -> Response
        end.