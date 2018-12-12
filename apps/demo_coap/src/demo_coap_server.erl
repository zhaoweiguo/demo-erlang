%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Dec 2018 1:32 PM
%%%-------------------------------------------------------------------
-module(demo_coap_server).
-author("zhaoweiguo").
-behaviour(coap_resource).

%% API
-export([start_link/0]).

-export([coap_discover/2, coap_get/4, coap_post/4, coap_put/4, coap_delete/3,
  coap_observe/4, coap_unobserve/1, handle_info/2, coap_ack/2]).

-include_lib("gen_coap/include/coap.hrl").
-include_lib("gutils/include/gutil.hrl").

coap_discover(Prefix, _Args) ->
  ?LOGLN(""),
  ?LOGF("discover ~p~n", [Prefix]),
  [{absolute, Prefix++Name, []} || Name <- mnesia:dirty_all_keys(resources)].

coap_get(_ChId, Prefix, Name, Query) ->
  ?LOGLN(""),
  ?LOGF("get ~p ~p ~p~n", [Prefix, Name, Query]),
  case mnesia:dirty_read(resources, Name) of
    [{resources, Name, Resource}] ->
      ?LOGF("resource: ~p~n", [Resource]),
      Resource;
    [] -> {error, not_found}
  end.

coap_post(_ChId, _Prefix, [<<"stop">>], _Content) ->
  ?LOGLN(""),
  main ! stop,
  {ok, content, #coap_content{}};
coap_post(_ChId, Prefix, Name, Content) ->
  ?LOGLN(""),
  ?LOGF("post ~p ~p ~p~n", [Prefix, Name, Content]),
  {error, method_not_allowed}.

coap_put(_ChId, Prefix, Name, Content) ->
  ?LOGLN(""),
  ?LOGF("put ~p ~p ~p~n", [Prefix, Name, Content]),
  mnesia:dirty_write(resources, {resources, Name, Content}),
  coap_responder:notify(Prefix++Name, Content),
  ok.

coap_delete(_ChId, Prefix, Name) ->
  ?LOGLN(""),
  ?LOGF("delete ~p ~p~n", [Prefix, Name]),
  mnesia:dirty_delete(resources, Name),
  coap_responder:notify(Prefix++Name, {error, not_found}),
  ok.

coap_observe(_ChId, Prefix, Name, _Ack) ->
  ?LOGLN(""),
  ?LOGF("observe ~p ~p~n", [Prefix, Name]),
  {ok, {state, Prefix, Name}}.

coap_unobserve({state, Prefix, Name}) ->
  ?LOGLN(""),
  ?LOGF("unobserve ~p ~p~n", [Prefix, Name]),
  ok.

handle_info(_Message, State) -> {noreply, State}.
coap_ack(_Ref, State) -> {ok, State}.

start_link() ->
%%  register(main, self()),
  ok = application:start(mnesia),
  {atomic, ok} = mnesia:create_table(resources, []),
  {ok, _} = application:ensure_all_started(gen_coap),
  {ok, _} = coap_server:start_udp(coap_udp_socket),
%%  {ok, _} = coap_server:start_dtls(coap_dtls_socket, [{certfile, "cert.pem"}, {keyfile, "key.pem"}]),
  coap_server_registry:add_handler([], ?MODULE, undefined).

