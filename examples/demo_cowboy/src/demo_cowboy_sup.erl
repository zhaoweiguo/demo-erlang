-module(demo_cowboy_sup).
-behaviour(supervisor).

-include_lib("gutils/include/gutil.hrl").

-export([start_link/0]).
-export([init/1]).



start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [?CHILD(demo_cowboy_servers_sup, supervisor)],
	{ok, {{one_for_one, 1, 5}, Procs}}.
