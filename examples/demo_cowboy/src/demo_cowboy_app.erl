-module(demo_cowboy_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->

	Dispatch = cowboy_router:compile([
		{'_', [	{"/", demo_cowboy_handler, []},
				{"/websocket/", demo_cowboy_websocket, []}]}
	]),
	{ok, _} = cowboy:start_clear(my_http_listener,
		[{port, 8081}],
		#{env => #{dispatch => Dispatch}}
	),

	demo_cowboy_sup:start_link().

stop(_State) ->
	ok.
