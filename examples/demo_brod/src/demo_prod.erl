%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jan 2019 2:46 PM
%%%-------------------------------------------------------------------
-module(demo_prod).
-author("zhaoweiguo").

%% API
-export([start/0]).

start() ->
    application:ensure_all_started(brod),
    application:start(deom_brod).



