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
-export([start/1, loop/2, doit/2]).

-define(MSG, <<"123456789qwertyuiopasdfghjklzxcvbnm">>).
-define(FILENAME, "/tmp/speed_delayfile.log").
%%-define(OPTIONS, [append, raw]).
-define(OPTIONS, [append, raw]).

-define(DELAY_SIZE, 5000).
-define(DELAY_TIME, 1000).

loop(Times, Num) ->
  loop(Times, Num, ?DELAY_SIZE, ?DELAY_TIME).


loop(0, _, _, _) ->
  ok;
loop(Times, Num, Delay, Size) ->
  start(Num, Delay, Size),
  timer:sleep(100),
  loop(Times - 1, Num).

start(Num) ->
  start(Num, ?DELAY_SIZE, ?DELAY_TIME).

start(Num, Delay, Size) ->
  Options = ?OPTIONS ++ [{delayed_write, Delay, Size}],
  {ok, FD} = file:open(?FILENAME, Options),
  {Time, _} = timer:tc(speed_delayfile, doit, [Num, FD]),
  io:format("time:~p~n", [Time]).

doit(0, _) ->
  io:format("doit done."),
  ok;
doit(Num, FD) ->
  doitonce(FD),
  doit(Num-1, FD).

doitonce(FD) ->
  file:write(FD, ?MSG).







