%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dec 2018 10:15 AM
%%%-------------------------------------------------------------------
-module(demo_cowboy_auth).
-author("zhaoweiguo").
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
  % @todo 验证deviceid，限制非合法设备请求
  %     1. 此设备使用过, ok
  %     2. 此设备未使用过，按deviceid的生成规则验证
  % @todo 请求数据保存，另写程序分析判断恶意请求
  % @todo 验证成功，
  %   1. 取出设备id,并把{DeviceId, Pid}=>mnesia
  %   2. 生成accessToken给设备, {DeviceId, Token}=>mnesia
  Req = cowboy_req:reply(200,
    #{<<"content-type">> => <<"application/json">>},
%%    #{<<"content-type">> => <<"text/plain">>},
    jsx:encode([{token, <<"token">>}]),
    Req0),
  {ok, Req, State}.
%%  {stop, Req, State}.

