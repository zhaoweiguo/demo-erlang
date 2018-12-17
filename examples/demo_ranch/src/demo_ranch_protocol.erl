%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dec 2018 5:26 PM
%%%-------------------------------------------------------------------
-module(demo_ranch_protocol).
-author("zhaoweiguo").
-behaviour(ranch_protocol).

-include_lib("gutils/include/gutil.hrl").

-export([start_link/4]).
-export([init/3]).


start_link(Ref, _Socket, Transport, Opts) ->
  ?LOGLN(""),
  ?LOGF("transport:~p~n", [Transport]),
  Pid = spawn_link(?MODULE, init, [Ref, Transport, Opts]),
  {ok, Pid}.

init(Ref, Transport, _Opts = []) ->
  ?LOGLN(""),
  {ok, Socket} = ranch:handshake(Ref),
  loop(Socket, Transport).

loop(Socket, Transport) ->
  ?LOGLN(""),
  case Transport:recv(Socket, 0, 5000) of
    {ok, Data} ->
      ?LOGF("data:~p~n", [Data]),
      Transport:send(Socket, Data),
      loop(Socket, Transport);
    Other ->
      ?LOGF("other:~p~n", [Other]),
      ok = Transport:close(Socket)
  end.
