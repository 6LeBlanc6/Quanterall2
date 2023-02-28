-module(bulls_and_cows).
-export([play/0]).

play() ->
    Secret = generate_secret(),
    play(Secret, 0).

play(Secret, Attempts) ->
    io:fwrite("Guess the number: "),
    Guess = io:get_line(""),
    {Bulls, Cows} = check_guess(Secret, Guess),
    io:fwrite("Bulls: ~p, Cows: ~p~n", [Bulls, Cows]),
    case {Bulls, Cows} of
        {4, 0} ->
            io:fwrite("You guessed the number in ~p attempts!~n", [Attempts + 1]);
        _ ->
            play(Secret, Attempts + 1)
    end.

generate_secret() ->
    lists:reverse(integer_to_list(rand:uniform(10000))).

check_guess(Secret, Guess) ->
    SecretList = lists:reverse(integer_to_list(Secret)),
    GuessList = string:to_list(Guess),
    {count_bulls(SecretList, GuessList), count_cows(SecretList, GuessList)}.

count_bulls(SecretList, GuessList) ->
    length(lists:filter(fun(X) -> lists:nth(X, SecretList) == lists:nth(X, GuessList) end, lists:seq(1, 4))).

count_cows(SecretList, GuessList) ->
    length(lists:filter(fun(X) -> lists:member(lists:nth(X, GuessList), SecretList) end, lists:filter(fun(X) -> lists:nth(X, SecretList) /= lists:nth(X, GuessList) end, lists:seq(1, 4)))).
