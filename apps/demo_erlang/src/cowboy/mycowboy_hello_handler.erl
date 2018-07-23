%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%   最简单实例，测试cowboy
%%% @end
%%% Created : 23. 七月 2018 下午3:50
%%%-------------------------------------------------------------------
-module(mycowboy_hello_handler).
-author("zhaoweiguo").

%% API
-export([init/2]).

init(Req0, State) ->
  Req = cowboy_req:reply(200,
    #{<<"content-type">> => <<"text/plain">>},
    <<"Hello Erlang!">>,
    Req0),
  {ok, Req, State}.