%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Dec 2018 8:07 PM
%%%-------------------------------------------------------------------
-module(demo_gun).
-author("zhaoweiguo").

-include_lib("gutils/include/gutil.hrl").

%% API
-export([start/0, stop/0]).
-export([socket_start/1]).


start() ->
  application:ensure_all_started(lager),
  application:ensure_all_started(gun),
  application:start(demo_gun).

stop() ->
  application:stop(demo_gun),
  application:stop(gun).



socket_start(Num) ->
  ProcName = list_to_atom(lists:flatten(io_lib:format("~p_~p", [demo_gun_clientsock, Num]))),
  Child = {{demo_gun_clientsock, Num}, {demo_gun_clientsock, start_link, [ProcName]},
    permanent, 5000, worker, [demo_gun_clientsock]},
  supervisor:start_child(demo_gun_clientsock_sup, Child).


