-module(demo_cowboy_websocket).
-behavior(cowboy_handler).

-include("demo_cowboy.hrl").

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, State) ->
  ?LOGLN(""),
  ?LOGF("pid:~p~n", [self()]),
%%  {Peer, _} = cowboy_req:peer(Req),
%%  util_l:log("peer:~n", [Peer]),
  #{token := Token} = cowboy_req:match_qs([token], Req),
  case check_token(Token) of
    true ->
      {cowboy_websocket, Req, State, #{
          idle_timeout => 30000,
          max_frame_size => 8000000}};
    _Other ->
      Req0 = cowboy_req:reply(404, Req),
      {ok, Req0, State}
  end.


websocket_init(State) ->
  ?LOGLN(""),
  ?LOGF("pid:~p~n", [self()]),
  % @todo 新增oct_sock_device处理此请求
  {ok, State}.

%%{
%%  "auth" : {
%%    "accessToken":"access token",
%%    "deviceId":"10000012"
%%  }
%%  "header":{
%%    "namespace":"Lenovo.Iot.Device.Control",
%%    "name":"TurnOn",
%%    "messageId":"1bd5d003-31b9-476f-ad03-71d471922820",
%%    "payLoadVersion":1
%%  },
%%  "payload":{
%%    "deviceId":"10000012",
%%    "deviceType":"light",
%%    "attribute":"powerstate",
%%    "value":"on",
%%    "extensions":{
%%      "extension1":"",
%%      "extension2":""
%%    }
%%  }
%%}
websocket_handle(_Frame = {text, Msg}, State) ->
  ?LOGLN(""),
  ?LOGF("pid:~p~n", [self()]),
  ?LOGF("Msg:~p~n", [Msg]),
  %% @todo token是否正确
  %% @todo loadbalance => oct_server处理请求
  Pid =self(),
  demo_cowboy_worker:send_msg(Msg, Pid),
  {reply, {text, <<"return: ", Msg/binary>>}, State};
websocket_handle(_Frame, State) ->
  ?LOGLN(""),
  {ok, State}.


websocket_info(exit, State) ->
  ?LOGLN(""),
  {stop, State};
websocket_info({exit, Reason}, State) ->
  ?LOGLN(""),
  ?LOGF("reason:~p~n", [Reason]),
  {reply, {close, 1000, Reason}, State};
websocket_info({text, Text}, State) ->
  ?LOGLN(""),
  ?LOGF("text:~p~n", [Text]),
  {reply, {text, Text}, State};
websocket_info(_Info, State) ->
  ?LOGLN(""),
  ?LOGF("_Info:~p~n", [_Info]),
  {ok, State}.



%% ============================
%%  inner function
%% ============================

check_token(_Token) ->
  % @todo check token
  true.





