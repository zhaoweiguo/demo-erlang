%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Nov 2018 9:48 AM
%%%-------------------------------------------------------------------
-module(speed_file).
-author("zhaoweiguo").

%% API
-export([start/1, loop/2, doit/2]).

-define(MSG, <<"123456789qwertyuiopasdfghjklzxcvbnm">>).
-define(FILENAME, "/tmp/speed_file.log").
-define(OPTIONS, [append, raw]).
%%-define(OPTIONS, [append, raw, {delayed_write, Size, Interval}]).

loop(0, _) ->
  ok;
loop(Times, Num) ->
  start(Num),
  timer:sleep(100),
  loop(Times - 1, Num).

start(Num) ->
  {ok, FD} = file:open(?FILENAME, ?OPTIONS),
  {Time, _} = timer:tc(speed_file, doit, [Num, FD]),
  io:format("time:~p~n", [Time]).

doit(0, _) ->
  io:format("doit done."),
  ok;
doit(Num, FD) ->
  doitonce(FD),
  doit(Num-1, FD).

doitonce(FD) ->
  file:write(FD, ?MSG).







