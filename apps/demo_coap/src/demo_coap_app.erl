%%%-------------------------------------------------------------------
%% @doc demo_coap public API
%% @end
%%%-------------------------------------------------------------------

-module(demo_coap_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [	{"/", demo_cowboy_handler, []},
            {"/websocket/", demo_cowboy_websocket, []}]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8081}],
        #{env => #{dispatch => Dispatch}}
    ),

    demo_coap_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
