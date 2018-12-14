%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Dec 2018 8:08 PM
%%%-------------------------------------------------------------------
-module(demo_gun_client).
-author("zhaoweiguo").

-include_lib("gutils/include/gutil.hrl").

%% API
-export([get/0, get/1]).


get() ->
  demo_gun_client:get("www.baidu.com").

get(Url) ->
  {ok, ConnPid} = gun:open(Url, 80),
  MRef = monitor(process, ConnPid),
%%  {ok, Protocol} = gun:await_up(ConnPid),
  StreamRef = gun:get(ConnPid, Url),
  receive
    {gun_response, ConnPid, StreamRef, fin, Status, Headers} ->
      ?LOGLN(""),
      no_data;
    {gun_response, ConnPid, StreamRef, nofin, Status, Headers} ->
      ?LOGLN(""),
      receive_data(ConnPid, MRef, StreamRef);
    {'DOWN', MRef, process, ConnPid, Reason} ->
      ?LOGLN(""),
      error_logger:error_msg("Oops!"),
      exit(Reason)
  after 1000 ->
    ?LOGLN(""),
    exit(timeout)
  end,

gun:close(ConnPid).



receive_data(ConnPid, MRef, StreamRef) ->
  receive
    {gun_data, ConnPid, StreamRef, nofin, Data} ->
      ?LOGLN(""),
      io:format("~s~n", [Data]),
      receive_data(ConnPid, MRef, StreamRef);
    {gun_data, ConnPid, StreamRef, fin, Data} ->
      ?LOGLN(""),
      ?LOGF("data:~p~n", [Data]),
      io:format("~s~n", [Data]);
    {'DOWN', MRef, process, ConnPid, Reason} ->
      ?LOGLN(""),
      error_logger:error_msg("Oops!"),
      exit(Reason)
  after 1000 ->
    ?LOGLN(""),
    exit(timeout)
  end.
