-module(task3).
-export([loop/1, start/4]).

start(N, M, A, X) ->
    Supervisor = spawn(task3, loop, [ {N, M, A, self(), []} ] ),
    Supervisor ! {initiate_process_arrow},
    Supervisor ! {create_child},
        receive
                {last_alive, LastAlive} -> LastAlive ! {do, {calc, X}};
                Any -> io:format("Any: ~p~n", [Any])
            end.
%Supervisor -> P1 -> P2 -> P3                                
%P3 -> P4 -> P5 -> P6
%N = 4
%M = 2
%A = 2
%State = {N, M, A, Supervisor, [P1, P2, P3, P4]}

%   cmds for shell
% Supervisor = task:start(0).
% Supervisor ! {initiate_process_arrow}.
% Supervisor ! {create_child}.
% is_process_alive(<0.88.0>).

% Supervisor = task3:start(0, 0, 0, 7).

loop( {5, _, _, Supervisor, []} ) -> Supervisor ! {last_alive, Supervisor};
loop( {_, 3, _, Supervisor, []} ) -> Supervisor ! {last_alive, Supervisor};
loop( {_, _, 3, Supervisor, []} ) -> Supervisor ! {last_alive, Supervisor};

%loop( {6, Supervisor, []} ) -> Supervisor ! {last_alive, Supervisor};

loop(State) -> 
        receive
            {initiate_process_arrow} -> { N, M, A, Supervisor, []} = State,
                    
                P1 = spawn(task3, loop, [ {N, M +1, A, self(), []} ]),                                    
                    io:format("M: ~p, Supervisor: ~p, P1: ~p~n", [M, Supervisor, P1]),
                        P1 ! {create_child_p1},
                
                P2 = spawn(task3, loop, [ {N, M, A +1, self(), []} ]),                                 
                    io:format("A: ~p, Supervisor: ~p, Me: ~p, P2: ~p~n", [A, Supervisor, self(), P2]),
                        %Supervisor ! {create_child}, %- zashto tazi komanda ne se izpylnqva za da startira/syzdade create_child sama ?
                        P2 ! {create_child_p2},
                                NewState = State;

            {create_child} -> { N, M, A, Supervisor, _} = State,
                P3 = spawn(task3, loop, [ {N +1, M, A, self(), []} ]),
                    io:format("N: ~p, Supervisor: ~p, Me: ~p, P3: ~p~n", [N, Supervisor, self(), P3]),
                        P3 ! {create_child},
                                 NewState = State;
                                            {do, {calc, X}} -> { N, _M, _A, Supervisor, _P3} = State,
                                            S = X*X,
                                            io:format("N:~p, S:~p~n", [N, S]),
                                            Supervisor ! {do, {calc, S}},
                                 NewState = State;
            {last_alive, LastAlive} -> {_N, _M, _A, Supervisor, _P3} = State,
                                            Supervisor ! {last_alive, LastAlive},          
                                 NewState = State;


            {create_child_p1} -> { N, M, A, Supervisor, _} = State,
               P1 = spawn(task3, loop, [ {N, M +1, A, self(), []} ]),                                   
                   io:format("M: ~p, Supervisor: ~p, Me: ~p, P1: ~p~n", [M, Supervisor, self(), P1]),
                        P1 ! {create_child_p1},
                                NewState = State;

            {create_child_p2} -> { N, M, A, Supervisor, _} = State,
               P2 = spawn(task3, loop, [ {N, M, A +1, self(), []} ]),                                   
                   io:format("A: ~p, Supervisor: ~p, Me: ~p, P2: ~p~n", [A, Supervisor, self(), P2]),
                        P2 ! {create_child_p2},
                                NewState = State;

            Any -> io:format("Any: ~p~n", [Any]),
                                NewState = State
        end,
loop(NewState).

