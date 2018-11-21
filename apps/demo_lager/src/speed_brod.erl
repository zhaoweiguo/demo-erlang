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
-export([start/1, loop/2, doit/1]).

-define(MSG, <<"123456789qwertyuiopasdfghjklzxcvbnm">>).
-define(CLIENTID, ?MODULE).
-define(TOPIC, <<"topic">>).
-define(BROKER, [{"localhost", 9092}]).

loop(0, _) ->
  ok;
loop(Times, Num) ->
  start(Num),
  timer:sleep(100),
  loop(Times - 1, Num).

start(Num) ->
  {ok, _} = application:ensure_all_started(brod),

  ok = brod:start_client(?BROKER, ?CLIENTID, []),
  ok = brod:start_producer(?CLIENTID, ?TOPIC, []),

  timer:tc(speed_brod, doit, [Num]).

doit(0) ->
  io:format("doit done."),
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