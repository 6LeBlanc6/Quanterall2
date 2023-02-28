-module(task2).
-export([loop/1, start/2]).

start(N, AB) ->
    Supervisor = spawn(task2, loop, [ {N, self(), []} ] ),
    Supervisor ! {initiate_process_arrow},
    Supervisor ! {create_child},
        receive
                {last_alive, LastAlive} -> LastAlive ! {do, {calc, AB}};
               % {do, {calc, P, AC}} -> State = { N, Supervisor, AC, AB, P},
                %    P = AC + AC + AB,
                 %      io:format("N:~p, P:~p, AC: ~p~n", [N, P, AC]),
                       % NewState = State;
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

% Supervisor = task2:start(0, 10).

loop( {7, Supervisor, []} ) -> Supervisor ! {last_alive, Supervisor};

loop(State) -> 
        receive
            {initiate_process_arrow} -> { N, _Supervisor, []} = State,
                    
                P1 = spawn(task2, loop, [ {N, self(), []} ]),                                    %tozi proces nqma dyshterni procesi
                    io:format("N: ~p, Supervisor: ~p, P1: ~p~n", [N, self(), P1]),
                P2 = spawn(task2, loop, [ {N, self(), []} ]),                                    %tozi proces nqma dyshterni procesi
                    io:format("N: ~p, Supervisor: ~p, P2: ~p~n", [N, self(), P2]),
                        %Supervisor ! {create_child}, %- zashto tazi komanda ne se izpylnqva za da startira/syzdade create_child sama ?
                                NewState = State;

            {create_child} -> { N, Supervisor, _} = State,
                P3 = spawn(task2, loop, [ {N +1, self(), []} ]),
                    io:format("N: ~p, Supervisor: ~p, Me: ~p, P3: ~p~n", [N, Supervisor, self(), P3]),
                        P3 ! {create_child},
                                NewState = State;
                                            {do, {calc, AB}} -> { N, Supervisor, _P3} = State,
                                            AC = 3*AB,
                                            P = AC + AC,
                                            io:format("N:~p, AC:~p~n", [N, AC]),
                                            Supervisor ! {do, {calc, P, AC}},
                                 NewState = { N, Supervisor, _P3, P, AC};
            {last_alive, LastAlive} -> {_N, Supervisor, _P3} = State,
                                            Supervisor ! {last_alive, LastAlive}, 

                                 NewState = State;                   
            Any -> io:format("Any: ~p~n", [Any]),
                                NewState = State
        end,
loop(NewState).

