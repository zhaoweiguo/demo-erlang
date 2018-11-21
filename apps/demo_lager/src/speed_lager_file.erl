%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Nov 2018 12:18 PM
%%%-------------------------------------------------------------------
-module(speed_lager_file).
-author("zhaoweiguo").

-include("demo_lager.hrl").
%% API
-export([start/1, loop/2, doit/1]).

loop(Times, Num) ->
  loop(Times, Num, 0).

loop(0, _, _) ->
  ok;
loop(Times, Num, 0) ->
  {ok, _} = application:ensure_all_started(brod),
  {ok, _} = application:ensure_all_started(lager),

  application:set_env(lager, handlers, [
%%    {lager_console_backend, debug},
    {lager_file_backend, [
      {file, "info.log"},
      {level, info},
      {formatter, lager_default_formatter},
      {size, 104857600},
      {date, "$D0"},
      {count, 15},
      {formatter_config,
        [date, " ", time, "|", node, "|",severity,"|", module, "|", function, "|", line, "|", pid, "|", message]
      }
    ]}

  ]),
  application:stop(lager),
  application:start(lager),

  loop(Times, Num, 1);
loop(Times, Num, Flag) ->
  start(Num),
  timer:sleep(100),
  loop(Times - 1, Num, Flag).

start(Num) ->
  {Time, _} = timer:tc(speed_lager_kafka, doit, [Num]),
  io:format("time:~p~n", [Time]).

doit(0) ->
  io:format("done."),
  ok;
doit(Num) ->
  doitonce(),
  doit(Num-1).

doitonce() ->
  lager:info(?MSG).




