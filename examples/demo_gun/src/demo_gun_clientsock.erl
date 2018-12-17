%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Dec 2018 11:39 AM
%%%-------------------------------------------------------------------
-module(demo_gun_clientsock).
-author("zhaoweiguo").

-behavior(gen_server).

-include_lib("gutils/include/gutil.hrl").

%% API
-export([start/0, start_link/1, init/1]).
-export([handle_call/3, handle_cast/2, handle_info/2]).
-export([terminate/2, code_change/3]).

-record(state, {
  conn_pid
}).


start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, [], []).

start() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  {ok, _} = application:ensure_all_started(gun),
  {ok, ConnPid} = gun:open("localhost", 8081),
  lager:debug("Pid:~p~n", [ConnPid]),
  {ok, _Protocol} = gun:await_up(ConnPid),

  gun:ws_upgrade(ConnPid, "/websocket?token=abc"),
  {ok, #state{}, 1000}.

handle_call({msg, Msg}, _From, State) ->
  lager:debug(""),
  {reply, ok, State};
handle_call(Msg, _From, State) ->
  lager:debug(""),
  {reply, ok, State}.

handle_cast(Msg, State) ->
  lager:debug(""),
  {noreply, State}.

handle_info({gun_upgrade, ConnPid, _StreamRef, [<<"websocket">>], Headers} , State) ->
  lager:debug("gun_upgrade"),
  upgrade_success(ConnPid, Headers),
%%      timer:send_after(1000, msg);
  timer:sleep(1000),
  gun:ws_send(ConnPid, {text, "Hello!"}),
  {noreply, State};
handle_info({gun_response, ConnPid, _, _, Status, Headers}, State) ->
  lager:debug("gun_response"),
  exit({ws_upgrade_failed, Status, Headers}),
  {noreply, State};
handle_info({gun_error, _ConnPid, _StreamRef, Reason}, State) ->
  lager:debug("gun_error"),
  exit({ws_upgrade_failed, Reason}),
  {noreply, State};
handle_info({gun_ws, ConnPid, StreamRef, Frame}, State) ->
%%  lager:debug("gun_ws"),
  lager:debug("frame:~p~n", [Frame]),
  handle_frame(ConnPid, StreamRef, Frame),
  timer:sleep(3000),
  gun:ws_send(ConnPid, {text, "Hello!"}),
  {noreply, State};
handle_info({gun_down,ConnPid,ws,closed, A, B}, State=#state{conn_pid = ConnPid}) ->
  lager:debug("A:~p,   B:~p~n", [A, B]),
  gun:close(ConnPid),
  {noreply, State};
handle_info(timeout, State) ->
  lager:debug("timeout"),
  exit(timeout),
  {noreply, State};
handle_info(Msg, State) ->
  lager:debug("other:~p~n", [Msg]),
  {noreply, State}.

terminate(_Reason, _State) ->
  lager:debug(""),
  ok.

code_change(_OldVsn, State, _Extra) ->
  lager:debug(""),
  {ok, State}.



upgrade_success(ConnPid, Headers) ->
  lager:debug("Upgraded ~p. Success!~nHeaders:~p~n", [ConnPid, Headers]).


handle_frame(ConnPid, StreamRef, Frame) ->
%%  lager:debug("frame:~p~n", [Frame]),
  ok.


