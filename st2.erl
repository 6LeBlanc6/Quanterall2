-module(st2).
-export([printAll/1]).

printAll(Ys) ->
    case Ys of
        [] ->
            io:format("~n", []);

        [X|Xs] ->
            io:format("~p ", [X]),
            printAll(Xs)
        end.