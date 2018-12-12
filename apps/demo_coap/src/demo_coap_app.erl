%%%-------------------------------------------------------------------
%% @doc demo_coap public API
%% @end
%%%-------------------------------------------------------------------

-module(demo_coap_app).

-behaviour(application).

-include_lib("gutils/include/gutil.hrl").
%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    ?LOGLN(""),
%%    Dispatch = cowboy_router:compile([
%%        {'_', [	{"/", demo_cowboy_handler, []},
%%            {"/websocket/", demo_cowboy_websocket, []}]}
%%    ]),
%%    {ok, _} = cowboy:start_clear(my_http_listener,
%%        [{port, 8081}],
%%        #{env => #{dispatch => Dispatch}}
%%    ),

    register(main, self()),
    ok = application:start(mnesia),
    {atomic, ok} = mnesia:create_table(resources, []),
    {ok, _} = application:ensure_all_started(gen_coap),
    {ok, _} = coap_server:start_udp(coap_udp_socket),
    ?LOGLN(""),
%%  {ok, _} = coap_server:start_dtls(coap_dtls_socket, [{certfile, "cert.pem"}, {keyfile, "key.pem"}]),
    coap_server_registry:add_handler([<<"ps">>], demo_coap_server, []),
    ?LOGLN(""),
    demo_coap_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
