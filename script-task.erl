-module(rect1).
-export([loop/1, start/1]).

start(InitState) ->
    spawn(rect1, loop, [{InitState}]).

%State = S

loop(State) ->
    receive
        {Client, Request} ->
                            Response = ....
                            Client ! {self(), Response}
        {create} ->
        {destroy} ->
        end,
loop(NewState).


client(Server, Request) ->
    Server ! {self(), Request},
    receive
            {Server, Response} -> Response      %neshto se pravi s tozi response
        end
        {Server, Response}