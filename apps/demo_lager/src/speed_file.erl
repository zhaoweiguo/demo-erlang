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
-export([start/1, loop/2]).

-define(MSG, <<"123456789qwertyuiopasdfghjklzxcvbnm">>).
-define(FILENAME, "/tmp/speed_file.log").
-define(OPTIONS, [append, raw]).
%%-define(OPTIONS, [append, raw, {delayed_write, Size, Interval}]).

loop(0, _) ->
  ok;
loop(Times, Num) ->
  start(Num),
  timer:sleep(100),
  loop(Times - 1).

start(Num) ->
  {ok, FD} = file:open(?FILENAME, ?OPTIONS),
  timer:tc(doit(Num, FD)),
  ok.


doit(Num, FD) ->
  lists:foldl(doitonce(FD),0,lists:seq(1,Num)),
  ok.

doitonce(FD) ->
  file:write(FD, ?MSG),
  ok.







