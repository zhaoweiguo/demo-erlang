%%%-------------------------------------------------------------------
%% @doc demo_brod top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(demo_brod_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).


-define(CONSUMER_TOPICS ,[<<"nbiot-consumber-topic">>]).
-define(PRODUCER_TOPIC ,<<"nbiot-producer-topic">>).

-define(CALLBACK_MODULE, demo_brod_sup).

-define(CLIENT_ID, 'nb-iot-kafka-clientid').
-define(GROUP_ID, <<"nb-iot-kafka-groupid">>).

-define(DEFAULT_BROKER, [{"localhost", 9092}]).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: #{id => Id, start => {M, F, A}}
%% Optional keys are restart, shutdown, type, modules.
%% Before OTP 18 tuples must be used to specify a child. e.g.
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    Broker = ?DEFAULT_BROKER,
    ClientId = ?CLIENT_ID,
    ok = brod:start_client(Broker, ClientId, []),

    ok = brod:start_producer(ClientId, ?CONSUMER_TOPICS, []),
%%    ok = brod:start_consumer(ClientId, ?CONSUMER_TOPIC, []),
    GroupConfig = [
        {offset_commit_policy, commit_to_kafka_v2},
        {offset_commit_interval_seconds, 5}
    ],
    ConsumerConfig = [{begin_offset, latest}, {offset_reset_policy, reset_to_latest}],
    MessageType = message,
    {ok, _Subscriber} = brod:start_link_group_subscriber(
        ClientId, ?GROUP_ID, ?PRODUCER_TOPIC, GroupConfig,
        ConsumerConfig, MessageType,
        _CallbackModule = ?CALLBACK_MODULE,
        _CallbackInitArg = {ClientId, ?PRODUCER_TOPIC, MessageType}),
%%    Child_sub = child_spec(demo_brod_sub, {demo_brod_sub, start_link, []}, permanent, brutal_kill, worker),
%%    Child_pub = child_spec(demo_brod_pub, {demo_brod_pub, start_link, []}, permanent, brutal_kill, worker),

    {ok, { {one_for_all, 1, 5}, []} }.

%%====================================================================
%% Internal functions
%%====================================================================

child_spec(Id, Start, Restart, Shutdown, Type) ->
    #{
        id      => Id,
        start   => Start,
        restart => Restart,
        shutdown=> Shutdown,
        type    => Type
    }.

