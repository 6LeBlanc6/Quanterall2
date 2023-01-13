-module(ex1).
-export([my_func1/0, my_func2/2, my_func2/1]).

%----rabotim za sega samo s imenuvani funkcii

my_func1() -> ok.

%-------------------
my_func2(1) -> 1;

my_func2(5) -> 100;

my_func2(X) ->
	X.

%------------------
my_func2(X, Y) ->
		{X, Y}.
