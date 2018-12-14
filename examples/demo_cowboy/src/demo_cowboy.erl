%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2018 11:33 AM
%%%-------------------------------------------------------------------
-module(demo_cowboy).
-author("zhaoweiguo").

%% API
-export([start/0]).

start() ->
  application:ensure_all_started(demo_cowboy).



