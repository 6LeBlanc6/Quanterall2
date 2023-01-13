-module(ex2).
%            /# - broi argumenti vyv funkciqta
-export([loop/0, start/0]).

% v tqloto na edin proces moje da raboti samo edna funkciq. Vytre v tazi funkciq mojem da se obyrnem kym mnogo drugi, no osnovnata funkciq e samo 1
%      (modul, funkciq, argumenti)
start() ->
%  _ pred promenlivata ozna4ava 4e tq ne se izpolzva
    _P = spawn(ex2, loop, []).

%State =  {N}  N v skobite na dolniq red e State-a
loop(State) ->    %kolkoto argumenta ima gore, tolkova trqbva da ima i dolu v loop, v skobite
    receive
        1 ->    Result = 0 ,            
                io:format("Msg: 1, Result: ~p ~n", [Result]); 
    %     {X, Y} -> Z = X + Y;
    %     [X, Y, Z] -> {X, Y + Z};
        % {aaa, {X}} -> .....;
        % {idiot} -> ......;
        % ~p  - placeholder (stoinostta na Any shte byde slojena v  ~p), ~n - mini na nov red
        %Ako se sloji "1 -> ..." sled "Any ->" nikoga nqma da vleze v tozi rezultat zashtoto se izpylnqvat v reda v kojto sa napisani i Any shte matchne i 1-cata predi da e stignalo do neq
        Any -> 
            io:format("Any: ~p ~n", [Any]) 
        %predi end nqma zapetaq zashtoto igrae rolqta na zatvarqshta operatorna skoba
        % 5> P ! {1, aaaaa}. - pri predizvikvane na losha aritmetika procesa umira. Chislata v tuple trqbva da se syberat a nie podavame atom "aaaaa" 
            %=ERROR REPORT==== 22-Nov-2022::23:34:47.775855 ===
            %Error in process <0.80.0> with exit value: 
            %{badarith,[{erlang,'+',[1,aaaaa],[]},
            %{ex2,loop,0,[{file,"ex2.erl"},{line,13}]}]}
        end,
        NewState = State,
    loop(NewState).