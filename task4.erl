-module(task4).
-export([loop/1, start/4]).

start(N, M, A, X) ->
                    process_flag(trap_exit, true),
                        io:format("Shell Pid: ~p~n", [self()]),
    Supervisor = spawn_link(task4, loop, [ {N, M, A, self(), []} ] ),
    Supervisor ! {initiate_process_arrow},
    timer:sleep(2000),
    Supervisor ! {create_child},
        receive
              {last_alive, LastAlive} -> LastAlive ! {do, {calc, X}};
               % {do, {calc, X}} -> 
                 %                           S = X+100,
               %                             io:format("M:~p, S:~p~n", [M, S]);
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

% Supervisor = task4:start(0, 0, 0, 5).

loop( {5, _, _, Parent, []} ) -> Parent ! {last_alive, Parent};
loop( {_, 3, _, _Parent, []} ) -> okM;
            %{last_alive, Supervisor} ->  io:format("M is ok: ~p~n", ['M is ok']);
loop( {_, _, 3, _Parent, []} ) -> okA;

%loop( {6, Supervisor, []} ) -> Supervisor ! {last_alive, Supervisor};

loop(State) -> 
        receive
            {initiate_process_arrow} -> { N, M, A, Parent, []} = State,
                    
                P1 = spawn(task4, loop, [ {N, M +1, A, self(), []} ]),                                    
                    io:format("M: ~p, Parent: ~p, Me: ~p, P1: ~p~n", [M, Parent, self(), P1]),
                        P1 ! {create_child_p1},
                     %   P1 ! {do, {calc, S, X}},         

                P2 = spawn(task4, loop, [ {N, M, A +1, self(), [P1]} ]),                                 
                    io:format("A: ~p, Parent: ~p, Me: ~p, P2: ~p~n", [A, Parent, self(), P2]),
                        %Supervisor ! {create_child}, %- zashto tazi komanda ne se izpylnqva za da startira/syzdade create_child sama ?
                        P2 ! {create_child_p2},
                                NewState = { N, M, A, Parent, [P1, P2]};

            {do, {calco, K}} -> {Parent, [P1, P2], K, U} = State,
                       U = K + 100,
                        io:format("X:~p, K:~p~n", [K, U]),
                        NewState = {Parent, [P1, P2], K, U};

                                

            {create_child} -> { N, M, A, Parent, _} = State,
                P3 = spawn(task4, loop, [ {N +1, M, A, self(), []} ]),
                    io:format("N: ~p, Parent: ~p, Me: ~p, P3: ~p~n", [N, Parent, self(), P3]),

                P31 = spawn(task4, loop, [ {N, M, A, self(), []} ]),
                    io:format("N: ~p, Parent: ~p, Me: ~p, P31: ~p~n", [N, Parent, self(), P31]),

                P32 = spawn(task4, loop, [ {N, M, A, self(), []} ]),
                    io:format("N: ~p, Parent: ~p, Me: ~p, P32: ~p~n", [N, Parent, self(), P32]),

                        %P31 ! {update, {N, M, A, self(), [P3, P31, P32]}},
                        P3 ! {create_child},

                                 NewState = { N, M, A, Parent, [P3, P31, P32]},
                    io:format("NewState: ~p~n", [NewState]);

            %{update, {N, M, A, Supervisor, [P, P31, P32]}} -> NewState = { N, M, A, Supervisor, [P, P31, P32]};

                                            {do, {calc, X}} -> { N, _M, _A, Parent, [P2]} = State,
                                            S = X+5,
                                            K = S*2,
                                            io:format("N:~p, S:~p~n", [N, S]),
                                            Parent ! {do, {calc, S}},
                                            P2 ! {do, {calco, K}},
                                            %P31 ! {do, {calc, S}},
                                            %P32 ! {do, {calc, S}},
                                 NewState = State;
            {last_alive, LastAlive} -> {_N, _M, _A, Parent, [_P1, _P2, _P3]} = State,
                                            Parent ! {last_alive, LastAlive},          
                                 NewState = State;
% Supervisor = task:start(0, 0, 0, 7).

            {create_child_p1} -> { N, M, A, Parent, []} = State,
               P1 = spawn(task4, loop, [ {N, M +1, A, self(), []} ]),                                   
                   io:format("M: ~p, Parent: ~p, Me: ~p, P1: ~p~n", [M, Parent, self(), P1]),
                        P1 ! {create_child_p1},
                                NewState = State,
                    io:format("NewState: ~p~n", [NewState]);

            {create_child_p2} -> { N, M, A, Parent, _} = State,
               P2 = spawn(task4, loop, [ {N, M, A +1, self(), []} ]),                                   
                   io:format("A: ~p, Parent: ~p, Me: ~p, P2: ~p~n", [A, Parent, self(), P2]),
                        P2 ! {create_child_p2},
                        %P2 ! {do, {calc, X}},
                                NewState = State,
                    io:format("NewState: ~p~n", [NewState]);

            Any -> io:format("Any: ~p~n", [Any]),
                                NewState = State
        end,
                   %io:format("N: ~p, M: ~p, A: ~p, Supervisor: ~p~n", [N, M, A, Supervisor]),

loop(NewState).

