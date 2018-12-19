%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Dec 2018 2:14 PM
%%%-------------------------------------------------------------------
-module(demo_tcp_server_active).
-author("zhaoweiguo").

-behavior(gen_server).

-define(HEART_BEAT_MSG, <<"heartbeat\r\n">>).
-define(HEART_BEAT_TIME, 2000).

%% API
-export([start/0, terminate/1, send_msg/1]).

-export([start_link/0]).
-export([wait_send_msg/2]).
-export([heartbeat/1]).
%% cb
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).


-record(state, {
  socket
}).


start() ->
  lager:warning(""),
  Port = 5556,
  {ok, Socket} = gen_tcp:connect("localhost", Port, [{active, true}, {packet, line}]),
%%  Pid= spawn(demo_tcp_server, wait_send_msg, [self(), Socket]),
%%  Pid = demo_tcp_server:wait_send_msg(self(), Socket),
  Pid=1,
  gen_tcp:send(Socket, <<":1234567\r\n">>),
  spawn(?MODULE, heartbeat, [Socket]),
  loop(Socket, Pid).


loop(Socket, Pid) ->
  lager:warning(""),
  receive
    {tcp, Socket, Data} ->
      lager:warning("receive:~p~n", [Data]),
%%      demo_tcp_server_active:send_msg(Socket),
      loop(Socket, Pid);
    {error, closed} ->
      lager:warning("reason:~p~n", [closed]),
      gen_tcp:close(Socket);
    {error, Reason} ->
      lager:warning("reason:~p~n", [Reason]),
      gen_tcp:close(Socket);
    Other ->
      lager:warning("other:~p~n", [Other])
  end.

wait_send_msg(Pid, Socket) ->
  lager:warning("pid:~p", [Pid]),
  timer:sleep(3000),
  gen_tcp:send(Socket, <<"asdfg\r\n">>).

heartbeat(Socket) ->
  io:format("heartbeat~n"),
  case gen_tcp:send(Socket, ?HEART_BEAT_MSG) of
    ok ->
      timer:sleep(?HEART_BEAT_TIME),
      heartbeat(Socket);
    Other ->
      lager:warning("error:~p", [Other]),
      gen_tcp:close(Socket)
  end.



start_link() ->
  lager:warning(""),
  Port = 5556,
  {ok, Socket} = gen_tcp:connect("localhost", Port, [{active, once}, {packet, line}]),
%%    {ok, Socket} = gen_tcp:connect("localhost", Port, [{active, false}, {packet, 0}], 5000),
  gen_server:start_link({local, ?MODULE}, ?MODULE, [Socket], []).


init([Socket]) ->
  A = gen_tcp:recv(Socket,0),
  lager:warning("receive:~p~n", [A]),
  {ok, #state{socket = Socket}}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.



send_msg(Socket) ->
%%  lager:warning("Socket:~p", [Socket]),
  timer:sleep(4000),
  gen_tcp:send(Socket, <<"abcdefgh\r\n">>).

terminate(Socket) ->
  gen_tcp:close(Socket).
