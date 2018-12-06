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
  {cowboy_websocket, Req, State, #{idle_timeout => 30000,
    max_frame_size => 8000000}}.


websocket_init(State) ->
  % @todo 验证deviceid，限制非合法设备请求
  %     1. 此设备使用过, ok
  %     2. 此设备未使用过，按deviceid的生成规则验证
  % @todo 请求数据保存，另写程序分析判断恶意请求
  % @todo 验证成功，
  %   1. 取出设备id,并把{DeviceId, Pid}=>mnesia
  %   2. 生成accessToken给设备, {DeviceId, Token}=>mnesia
  % @todo 新增oct_sock_device处理此请求
  {ok, State}.

websocket_handle(_Frame = {text, Msg}, State) ->
  util_l:log("receive:~p~n", [Msg]),
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
  %% @todo token是否正确
  %% @todo loadbalance => oct_server处理请求
  {reply, {text, <<"That's what she said: ", Msg/binary>>}, State};
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
