%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jan 2019 2:46 PM
%%%-------------------------------------------------------------------
-module(demo_brod).
-author("zhaoweiguo").

%% API
-export([start/0]).

start() ->
    application:ensure_all_started(reloader),
    application:ensure_all_started(lager),
    application:ensure_all_started(brod),
    application:start(demo_brod).



