%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Nov 2018 9:48 AM
%%%-------------------------------------------------------------------
-module(speed_brod).
-author("zhaoweiguo").

%% API
-export([loop/2, doit/1]).

-include("demo_lager.hrl").


-define(CLIENTID, ?MODULE).
-define(TOPIC, <<"topic">>).
-define(BROKER, [{"localhost", 9092}]).

loop(Times, Num) ->
  {ok, _} = application:ensure_all_started(brod),

  ok = brod:start_client(?BROKER, ?CLIENTID, []),
  ok = brod:start_producer(?CLIENTID, ?TOPIC, []),
  loop1(Times, Num),
  brod:stop_client(?CLIENTID),
  ok.

loop1(0, _) ->
  ok;
loop1(Times, Num) ->
  start(Num),
  timer:sleep(100),
  loop1(Times - 1, Num).

start(Num) ->
  {Time, _} = timer:tc(?MODULE, doit, [Num]),
  Time2 = {Time div 1000 div 1000, Time div 1000 rem 1000, Time rem 1000},
  io:format("time:~p | ~p~n", [Time, Time2]).

doit(0) ->
  ok;
doit(Num) ->
  doitonce(),
  doit(Num -1).


doitonce() ->
  PartitionFun = fun(_Topic, Partition, _Key, _Value) ->
    {ok, crypto:rand_uniform(0, Partition)}
                 end,
%%  PartitionFun = 0,
  case brod:produce(?CLIENTID, ?TOPIC, PartitionFun, <<"">>, ?MSG) of
    {ok, _CallRef} ->
      ok;
    {error, Reason} ->
      % @todo send warning sms?
      io:format("Reason = ~p; ~n", [Reason])
  end.