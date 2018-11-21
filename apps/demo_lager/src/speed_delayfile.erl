%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Nov 2018 9:48 AM
%%%-------------------------------------------------------------------
-module(speed_delayfile).
-author("zhaoweiguo").

%% API
-export([loop/2, loop/4, doit/2]).

-include("demo_lager.hrl").

-define(FILENAME, "/tmp/speed_delayfile.log").
-define(OPTIONS, [append, raw]).

-define(DELAY_SIZE, 5000).
-define(DELAY_TIME, 1000).

%% @doc 入口函数
%% @param Times: 请求次数
%% @param Num: 一次执行次数
-spec loop(Times::integer(), Num::integer()) -> ok.
loop(Times, Num) ->
  loop(Times, Num, ?DELAY_SIZE, ?DELAY_TIME).

%% @doc 入口函数
%% @param Times: 请求次数
%% @param Num: 一次执行次数
%% @param Size: 数据大小超过Size bytes
%% @param Delay: 时间超过Delay milliseconds
loop(Times, Num, Size, Delay) ->
  Options = ?OPTIONS ++ [{delayed_write, Size, Delay}],
  {ok, FD} = file:open(?FILENAME, Options),
  loop(Times, Num, FD),
  file:close(FD),
  ok.



loop(0, _, _) ->
  ok;
loop(Times, Num, FD) ->
  start(Num, FD),
  timer:sleep(100),
  loop(Times - 1, Num, FD).


start(Num, FD) ->
  {Time, _} = timer:tc(?MODULE, doit, [Num, FD]),
  Time2 = {Time div 1000 div 1000, Time div 1000 rem 1000, Time div 1000},
  io:format("time:~p~n", [Time2]).

doit(0, _) ->
  ok;
doit(Num, FD) ->
  doitonce(FD),
  doit(Num-1, FD).

doitonce(FD) ->
  file:write(FD, ?MSG).







