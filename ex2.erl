-module(ex2).
%            /# - broi argumenti vyv funkciqta
-export([loop/1, start/0]).
% v tqloto na edin proces moje da raboti samo edna funkciq. Vytre v tazi funkciq mojem da se obyrnem kym mnogo drugi, no osnovnata funkciq e samo 1
%      (modul, funkciq, argumenti)
start() ->
%  _ pred promenlivata ozna4ava 4e tq ne se izpolzva
    _P = spawn(ex2, loop, [{5}]).
%State =  {N}  N v skobite na dolniq red e State-a
loop(State) ->    %kolkoto argumenta ima gore, tolkova trqbva da ima i dolu v loop, v skobite
    receive
        [_X, _Y, _Z] -> {N} = State,
                        NewState = {N + 5},
                        io:format("NewState: ~p ~n", [NewState]);
                    Any ->
                        io:format("Any: ~p ~n", [Any]),
                        NewState = State,
                        io:format("NewState: ~p ~n", [NewState])
        end,
    loop(NewState).