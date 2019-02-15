%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. Jan 2019 11:06 AM
%%%-------------------------------------------------------------------
-module(demo_gun_sock).
-author("zhaoweiguo").

-behaviour(gen_server).

%% API
-export([start_link/2]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).
-define(DELAY, 100).
-define(HEART_BEAT_MSG, <<"heartbeat">>).
-define(HEART_BEAT_TIME, 2000).

-record(state, {
    tag,
    args,
    conn_pid,
    heartbeat_timer
}).

%%%===================================================================
%%% API
%%%===================================================================

start_link(Tag, Args) ->
    gen_server:start_link(?MODULE, {Tag, Args}, []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init({Tag, Args}) ->
    lager:debug("---------------Tag=~p, Args=~p", [Tag, Args]),

    {Host, Port} = demo_gun_util:get_server_port(Tag),
    lager:debug("------------Host=~p, Port=~p", [Host, Port]),
    {ok, ConnPid} = gun:open(Host, Port),
    lager:warning("----------Pid:~p~n", [ConnPid]),
    case gun:await_up(ConnPid) of
        {ok, _Protocol} ->
            ok;
        Error ->
            lager:error("Error=~p", [Error])
    end,
    ws_upgrade(Tag, ConnPid, Args),

    {ok, #state{
        tag = Tag,
        args = Args,
        conn_pid = ConnPid
    }}.

handle_call(_Request, _From, State) ->
    lager:debug("_Request=~p", [_Request]),
    {reply, ok, State}.

handle_cast(_Request, State) ->
    lager:debug("_Request=~p", [_Request]),
    {noreply, State}.

handle_info({gun_upgrade, ConnPid, _StreamRef, [<<"websocket">>], Headers} , State) ->
    lager:warning("Upgraded ~p. Success!~nHeaders:~p~n", [ConnPid, Headers]),

    Timer = timer:send_after(?HEART_BEAT_TIME, ?HEART_BEAT_MSG),
    {noreply, State#state{heartbeat_timer = Timer}};
handle_info({gun_response, ConnPid, _StreamRef, _Fin, Status, Headers}, State=#state{conn_pid = ConnPid}) ->
    lager:warning("gun_response"),
    exit({ws_upgrade_failed, Status, Headers}),
    {noreply, State};
handle_info({gun_error, _ConnPid, _StreamRef, Reason}, State) ->
    lager:warning("gun_error"),
    exit({ws_upgrade_failed, Reason}),
    {noreply, State};
handle_info({gun_ws, ConnPid, StreamRef, Frame}, State) ->
%%  lager:warning("gun_ws"),
    lager:warning("frame:~p~n", [Frame]),
    timer:sleep(3000),
    gun:ws_send(ConnPid, {text, "[gun send]hello2!"}),
    {noreply, State};
handle_info({gun_down,ConnPid,ws,closed, A, B}, State=#state{conn_pid = ConnPid}) ->
    lager:warning("A:~p,   B:~p~n", [A, B]),
    gun:close(ConnPid),
    {noreply, State};
handle_info(timeout, State) ->
    lager:warning("timeout"),
    exit(timeout),
    {noreply, State};
%% 心跳
handle_info(?HEART_BEAT_MSG, State=#state{conn_pid = ConnPid}) ->
    io:format("heartbeat:gun~n"),
    gun:ws_send(ConnPid, {text, "heartbeat"}),
    Timer = timer:send_after(?HEART_BEAT_TIME, ?HEART_BEAT_MSG),
    {noreply, State#state{heartbeat_timer = Timer}};
handle_info(_Info, State) ->
    lager:debug("_Info=~p", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    lager:debug("_Reason=~p", [_Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

ws_upgrade(ledong, ConnPid, _Args={token, Token}) ->
    lager:debug("Token=~p", [Token]),
    gun:ws_upgrade(ConnPid, io_lib:format("/websocket?token=~p", [Token]));
ws_upgrade(client, ConnPid, _Args) ->
    lager:debug(""),
    gun:ws_upgrade(ConnPid, io_lib:format("/websocket?token=~p", [_Args]));
ws_upgrade(hub, ConnPid, _Args={HubId, Mac}) ->
    lager:debug("_Args=~p", [_Args]),
    gun:ws_upgrade(ConnPid, io_lib:format("/hub/comet?hub_id=~p&mac=~p&ver=v2.1", [HubId, Mac]));
ws_upgrade(Other, ConnPid, _Args) ->
    lager:debug("Other=~p, _Args=~p", [Other, _Args]).



