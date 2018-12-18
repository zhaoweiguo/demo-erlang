%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Dec 2018 2:30 PM
%%%-------------------------------------------------------------------
-module(demo_gun_clientsock_sup).
-author("zhaoweiguo").

-include_lib("gutils/include/gutil.hrl").

-behavior(supervisor).

%% API
-export([start_link/0, init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
  SupFlags = {one_for_one, 1000, 3600},
  Child1 = ?CHILD(demo_gun_clientsock, worker, [token1], token1),
  Child2 = ?CHILD(demo_gun_clientsock, worker, [token2], token2),
  Children = [Child1, Child2],
  {ok, {SupFlags, Children}}.


