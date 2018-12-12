%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dec 2018 10:02 PM
%%%-------------------------------------------------------------------
-module(demo_ranch).
-author("zhaoweiguo").

%% API
-export([start/0]).

start() ->
  application:ensure_all_started(demo_ranch).