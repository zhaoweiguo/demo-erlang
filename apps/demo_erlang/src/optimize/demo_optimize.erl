%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%   此模块主要用于测试同步、异步相关特性
%%%     请求N次call/cast请求
%%%   1. demo_optimize:index(sync1, N).
%%%     gen_server:call/3返回结果后再请求下次call
%%%   2. demo_optimize:index(sync2, N).
%%%     起N个进程,并发请求gen_server:call/3
%%%   3. demo_optimize:index(async1, N).
%%%     gen_server:cast/3返回结果后再请求下次cast
%%%   4. demo_optimize:index(async2, N).
%%%     起N个进程,并发请求gen_server:cast/3
%%% @end
%%% Created : 11. 十月 2018 上午10:41
%%%-------------------------------------------------------------------
-module(demo_optimize).
-author("zhaoweiguo").

%% API
-export([index/2]).
-export([doit/2, call/0, cast/0,call_timeout/0]).

-define(SERVER, demo_optimize_server).
-define(TIMEOUT, 10).

-spec index(Flag:: sync1 | sync2 | async1 | async2 | sync_timeout1 | sync_timeout2,
            N::integer()) -> ok.
index(Flag, N) ->
  gen_server:start_link({local, ?SERVER}, ?SERVER, [], []),
  io:format("num:"),
  spawn(?MODULE, doit, [Flag, N]),
  ok.


doit(sync1, N) ->
  call1s(N);
doit(sync2, N) ->
  call2s(N);
doit(async1, N) ->
  cast1s(N);
doit(async2, N) ->
  cast2s(N);
doit(sync_timeout1, N) ->
  call_timeout1s(N);
doit(async_timeout2, N) ->
  cast_timeout2s(N).

call1s(0) ->
  io:format("done.~n"),
  ok;
call1s(N) ->
  call(),
  call1s(N-1).

call2s(0) ->
  io:format("done.~n"),
  ok;
call2s(N) ->
  spawn(fun()->call() end),
  call2s(N-1).

call_timeout1s(0) ->
  io:format("done.~n"),
  ok;
call_timeout1s(N) ->
  call_timeout(),
  call_timeout1s(N-1).

cast_timeout2s(0) ->
  io:format("done.~n"),
  ok;
cast_timeout2s(N) ->
  spawn(fun() -> call_timeout() end),
  cast_timeout2s(N-1).

cast1s(0) ->
  io:format("done~n"),
  ok;
cast1s(N) ->
  cast(),
  cast1s(N-1).


cast2s(0) ->
  io:format("done~n"),
  ok;
cast2s(N) ->
  spawn(fun()-> cast() end),
  cast2s(N-1).




%% === inner ===

call() ->
  gen_server:call(?SERVER, doit).

cast() ->
  gen_server:cast(?SERVER, doit).

call_timeout() ->
  gen_server:call(?SERVER, doit, ?TIMEOUT).


