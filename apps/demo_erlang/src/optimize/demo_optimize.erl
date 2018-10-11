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
-export([doit/2, call/0, cast/0]).

-define(SERVER, demo_optimize_server).


-spec index(Flag:: sync1 | sync2 | async1 | async2, N::integer()) -> ok.
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
  cast2s(N).

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




