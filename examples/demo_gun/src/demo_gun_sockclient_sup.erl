%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Dec 2018 2:30 PM
%%%-------------------------------------------------------------------
-module(demo_gun_sockclient_sup).
-author("zhaoweiguo").

-include_lib("gutils/include/gutil.hrl").

-behavior(supervisor).

%% API
-export([start_link/0, init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
  SupFlags = #{
    strategy => simple_one_for_one,
    intensity => 0,
    period => 1
  },
  ChildSpecs = [#{
    id => demo_gun_sockclient,
    start => {demo_gun_sock, start_link, [client]},
    shutdown => brutal_kill

  }],
  {ok, {SupFlags, ChildSpecs}}.


