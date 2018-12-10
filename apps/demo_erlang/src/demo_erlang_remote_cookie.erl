%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Dec 2018 4:46 PM
%%%-------------------------------------------------------------------
-module(demo_erlang_remote_cookie).
-author("zhaoweiguo").

%% API
-export([index/0]).

index() ->
  Node1 = 'demo_cowboy@127.0.0.1',
  Cookie1 = 'demo_cowboy',
  Node2 = 'abc@127.0.0.1',
  Cookie2 = 'TOJDFJIGXMBXEAYQXJAV',

  spawn(loop(Node1, Cookie1)),
%%  spawn(loop(Node2, Cookie2)),
  ok.


loop(Node, Cookie) ->
  M = erlang,
  F = get_cookie,
  A = [],
  true = erlang:set_cookie(Node, Cookie),
  true = net_kernel:connect(Node),
  V = rpc:call(Node, M, F, A),
  io:format("v=~p~n", [V]),
  timer:sleep(3000),
  loop(Node, Cookie).







