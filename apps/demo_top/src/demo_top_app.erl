%%%-------------------------------------------------------------------
%% @doc demo_top public API
%% @end
%%%-------------------------------------------------------------------

-module(demo_top_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    demo_top_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================