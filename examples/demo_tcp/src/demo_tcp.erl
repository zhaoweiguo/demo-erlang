%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Dec 2018 8:02 PM
%%%-------------------------------------------------------------------
-module(demo_tcp).
-author("zhaoweiguo").

%% API
-export([start/0, stop/0]).


start() ->
  application:ensure_all_started(lager),
  application:start(demo_tcp).


stop() ->
  application:stop(demo_tcp).




