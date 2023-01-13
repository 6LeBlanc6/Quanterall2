-module(neuron2).
-export([start/1, loop/1, aloop/1, bloop/1, cloop/1]).

start(0) ->
    State0 = {[{0, test, Last_test1}, {0, alabala, Last_test2}, {0, [], Last_test3}]},
        P = spawn(neuron2, loop, [State0]),
        A = spawn(neuron2, aloop, [P]),
        B = spawn(neuron2, bloop, [P]),
        C = spawn(neuron2, cloop, [P]).

%State = {[{C1, Pt1}, {C2, Pt2}, {C3, Pt3}]}

loop(State) ->
    io:format("Ppid: ~p~n", [self()]),
        {[{C1, test}, {C2, alabala}, {C3, []}]} = State,
    receive
        {A, count} -> {L} = State,
                case lists:keyfind(test, 2, L) of
                    {C1, test} -> NewState = {[{C1 + 1, test}, {C2, alabala}, {C3, []}]},
                                io:format("NewState: ~p~n", [NewState]);

                        false -> NewState = State
                end;
        {B, count2} -> {L} = State,
                case lists:keyfind(alabala, 2, L) of
                    {C2, alabala} -> NewState = {[{C1, test}, {C2 + 1, alabala}, {C3, []}]},
                                io:format("NewState: ~p~n", [NewState]);
                        false -> NewState = State
                end;

        {C, count3} -> {L} = State,
                case lists:keyfind([], 2, L) of
                    {C3, []} -> NewState = {[{C1, test}, {C2, alabala}, {C3 + 1, []}]},
                                io:format("NewState: ~p~n", [NewState]);

                        false -> NewState = State
                end;

        Any -> NewState = State,
                 io:format("Any: ~p~n", [Any])
    end,
        loop(NewState).


aloop(P) ->
  io:format("Apid: ~p~n", [self()]),         
            receive
               test -> P ! {self(), count};

                Any -> no_count
            end,
                aloop(P).

bloop(P) ->
  io:format("Bpid: ~p~n", [self()]),         
            receive
               alabala -> P ! {self(), count2};

                Any -> no_count
            end,
                bloop(P).

cloop(P) ->
  io:format("Cpid: ~p~n", [self()]),        
            receive
               [] -> P ! {self(), count3};

                Any -> no_count
            end,
                cloop(P).