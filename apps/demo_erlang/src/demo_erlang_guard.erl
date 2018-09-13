%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 九月 2018 下午3:53
%%%-------------------------------------------------------------------
-module(demo_erlang_guard).
-author("zhaoweiguo").

%% API
-export([do/0]).


%
do() ->
  do1(1).

do1(A) when A/0==1 ; true ->
  io:format("part 1~n");
do1(_A) ->
  io:format("aaa~n").



