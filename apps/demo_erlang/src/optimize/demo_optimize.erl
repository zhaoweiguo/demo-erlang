%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十月 2018 上午10:41
%%%-------------------------------------------------------------------
-module(demo_optimize).
-author("zhaoweiguo").

%% API
-export([index/2]).

-define(SERVER, demo_optimize_server).


-spec index(Flag:: sync | async, N::integer()) -> ok.
index(Flag, N) ->
  gen_server:start_link({local, ?SERVER}, ?SERVER, [], []),
  io:format("num:"),
  spawn(?MODULE, doit, [Flag, N]),
  ok.


doit(sync, N) ->
  calls(N);
doit(async, N) ->
  casts(N).

calls(0) ->
  io:format("done.~n"),
  ok;
calls(N) ->
  spawn(fun()-> call() end),
  calls(N-1).

call() ->
  gen_server:call(?SERVER, doit).



casts(0) ->
  io:format("done~n"),
  ok;
casts(N) ->
  spawn(fun()-> cast() end),
  casts(N-1).

cast() ->
  gen_server:cast(?SERVER, doit).




