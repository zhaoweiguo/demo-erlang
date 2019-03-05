%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Feb 2019 1:41 PM
%%%-------------------------------------------------------------------
-module(demo_udp).
-author("zhaoweiguo").

%% API
-export([start/0, stop/0]).

start() ->
    application:ensure_all_started(lager),
    application:start(demo_udp).

stop() ->
    application:stop(demo_udp).


