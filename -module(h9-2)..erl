-module(h9).
-export([loop/1]).


%State = {func, F}

loop(State) ->


    receive
        {change_func, NewF} -> NewState = {func, NewF};
        {pt1} -> ok;
        {pt2} -> ok;
        Any -> Any
    end,
    loop(NewState).

create_f1() ->
    fun() ->
        receive
            {change_func, NewF} -> NewState = {func, NewF};
            {pt1} -> ok;
            {pt2} -> ok;
            Any -> Any
        end
    end.

    
    
   % [F(X) || X <- PaternList]