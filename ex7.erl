-module(ex7).
-export([loop/1, start/1]).

%start() ->
%    P = spawn(ex7, loop, []).
start(F) ->
    spawn(ex7, loop, [{func, F}]).

loop(State) ->
          receive
        {do, X} -> {func, MyFunc} = State,
                MyFunc(X),
                NewState = State;
        
        %{func, F} -> F(),
                %NewState = State;
            Any -> io:format("Any = ~p~n", [Any]),
            NewState = State
        end,
    loop(NewState).