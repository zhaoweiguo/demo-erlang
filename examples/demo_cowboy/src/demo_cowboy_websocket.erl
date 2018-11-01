-module(demo_cowboy_websocket).
-behavior(cowboy_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, State) ->
  util_l:log("start..."),
%%  {Peer, _} = cowboy_req:peer(Req),
%%  util_l:log("peer:~n", [Peer]),
%%  cowboy_req:qs_val(<<"user_id">>, Req),
  {cowboy_websocket, Req, State, #{ idle_timeout => 30000,
                                    max_frame_size => 8000000}}.


websocket_init(State) ->
    {ok, State}.

websocket_handle(_Frame = {text, Msg}, State) ->
  util_l:log("receive:~p~n", [Msg]),
  {reply, {text, << "That's what she said: ", Msg/binary >>}, State};
websocket_handle(_Frame, State) ->
  util_l:log("receive: other"),
  {ok, State}.


websocket_info(exit, State) ->
  util_l:log("info: exit"),
  {stop, State};
websocket_info({exit, Reason}, State) ->
  util_l:log("info: {exit, ~p}", [Reason]),
  {reply, {close, 1000, Reason}, State};
websocket_info({text, Text}, State) ->
  util_l:log("info: {text, ~p}", [Text]),
  {reply, {text, Text}, State};
websocket_info(_Info, State) ->
  util_l:log("info: other"),
  {ok, State}.
