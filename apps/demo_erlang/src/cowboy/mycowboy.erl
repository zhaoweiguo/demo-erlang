%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%   cowboy入口
%%% @end
%%% Created : 23. 七月 2018 下午3:38
%%%-------------------------------------------------------------------
-module(mycowboy).
-author("zhaoweiguo").

%% API
-export([start/2]).

start(_Type, _Args) ->
  Dispatch = cowboy_router:compile([
    {'_', [{"/", mycowboy_hello_handler, []}]}
  ]),
  {ok, _} = cowboy:start_clear(http,
    [{port, 8080}],
    #{env => #{dispatch => Dispatch}}
  ).





