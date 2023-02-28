-module(task2f).
-export([loop/1, start/2]).

start(N, X) ->
    Supervisor = spawn(task2f, loop, [ {N, self(), []} ] ),
    Supervisor ! {initiate_process_arrow},
    Supervisor ! {create_child},
        receive
                {last_alive, LastAlive} -> LastAlive ! {do, {calc, X}};
                Any -> io:format("Any: ~p~n", [Any])
            end.
%Supervisor -> P1 -> P2 -> P3                                
%P3 -> P4 -> P5 -> P6
%N = 6

%State = {N, Supervisor, [P1, P2, P3, P4]}

%   cmds for shell
% Supervisor = task2:start(0,2).
% Supervisor ! {initiate_process_arrow}.
% Supervisor ! {create_child}.
% is_process_alive(<0.88.0>).

% Supervisor = task2f:start(0, 7).

loop( {4, Supervisor, []} ) -> Supervisor ! {last_alive, Supervisor};

loop(State) -> 
        receive
            {initiate_process_arrow} -> { N, _Supervisor, []} = State,
                    
                P1 = spawn(task2f, loop, [ {N, self(), []} ]),                                    %tozi proces nqma dyshterni procesi
                    io:format("N: ~p, Supervisor: ~p, P1: ~p~n", [N, self(), P1]),
                P2 = spawn(task2f, loop, [ {N, self(), []} ]),                                    %tozi proces nqma dyshterni procesi
                    io:format("N: ~p, Supervisor: ~p, P2: ~p~n", [N, self(), P2]),
                        %Supervisor ! {create_child}, %- zashto tazi komanda ne se izpylnqva za da startira/syzdade create_child sama ?
                                NewState = State;

            {create_child} -> { N, Supervisor, _} = State,
                P3 = spawn(task2f, loop, [ {N +1, self(), []} ]),
                    io:format("N: ~p, Supervisor: ~p, Me: ~p, P3: ~p~n", [N, Supervisor, self(), P3]),
                        P3 ! {create_child},
                                NewState = State;
                                            {do, {calc, X}} -> { N, Supervisor, _P3} = State,
                                            S = X*X,
                                            io:format("N:~p, S:~p~n", [N, S]),
                                            Supervisor ! {do, {calc, S}},
                                 NewState = State;
            {last_alive, LastAlive} -> {_N, Supervisor, _P3} = State,
                                            Supervisor ! {last_alive, LastAlive}, 

                                 NewState = State;                   
            Any -> io:format("Any: ~p~n", [Any]),
                                NewState = State
        end,
loop(NewState).

