%%%-------------------------------------------------------------------
%% @doc demo_clique public API
%% @end
%%%-------------------------------------------------------------------

-module(demo_clique_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    demo_clique_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
