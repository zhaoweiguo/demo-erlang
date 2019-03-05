%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Feb 2019 3:11 PM
%%%-------------------------------------------------------------------
-module(gen_udp_server).
-author("zhaoweiguo").

%% API
-export([]).


-behavior(gen_server).

%% API
-export([start/0, terminate/1, send_msg/1]).

-export([start_link/0]).
-export([wait_send_msg/2]).
%% cb
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).


-record(state, {
    socket
}).


start() ->
    lager:warning(""),
    Port = 5556,
    {ok, Socket} = gen_udp:open(Port, [{active, false}]),
%%  Pid= spawn(demo_tcp_server, wait_send_msg, [self(), Socket]),
%%  Pid = demo_tcp_server:wait_send_msg(self(), Socket),
    Pid=1,
    loop(Socket, Pid).


loop(Socket, Pid) ->
    lager:warning(""),
%%  spawn(demo_tcp_server, send_msg, [Socket]),
    case gen_tcp:recv(Socket,0) of
        {ok, {Address, Port, Packet}} ->
            lager:warning("receive:~p~n", [Data]),
            demo_tcp_server:send_msg(Socket),
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



start_link() ->
    lager:warning(""),
    Port = 5556,
    {ok, Socket} = gen_tcp:connect("localhost", Port, [{active, once}, {packet, 0}]),
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
    lager:warning("Socket:~p", [Socket]),
    timer:sleep(4000),
    gen_tcp:send(Socket, <<"1234567890\r\n">>).

terminate(Socket) ->
    gen_tcp:close(Socket).

