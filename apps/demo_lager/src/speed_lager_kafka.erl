%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Nov 2018 12:18 PM
%%%-------------------------------------------------------------------
-module(speed_lager_kafka).
-author("zhaoweiguo").

-include("demo_lager.hrl").
%% API
-export([start/1, loop/2, doit/1]).

loop(Times, Num) ->
  {ok, _} = application:ensure_all_started(brod),
  {ok, _} = application:ensure_all_started(lager),

  application:set_env(lager, handlers, [
%%    {lager_console_backend, debug},
    {lager_kafka_backend, [
      {level,                         "info"},
      {topic,                         <<"topic">>},
      {broker,                        [{"localhost", 9092}]},
      {send_method,                   async},
      {formatter,                     lager_default_formatter},
      {formatter_config,
        [date, " ", time, "|", node, "|",severity,"|", module, "|", function, "|", line, "|", pid, "|", message]
      }
    ]
    }
  ]),
  application:stop(lager),
  application:start(lager),
  loop1(Times, Num),
  ok.

loop1(0, _) ->
  ok;
loop1(Times, Num) ->
  start(Num),
  timer:sleep(100),
  loop1(Times - 1, Num).

start(Num) ->
  {Time, _} = timer:tc(?MODULE, doit, [Num]),
  io:format("time:~p~n", [Time]).

doit(0) ->
  io:format("done."),
  ok;
doit(Num) ->
  doitonce(),
  doit(Num-1).

doitonce() ->
  lager:info(?MSG).





