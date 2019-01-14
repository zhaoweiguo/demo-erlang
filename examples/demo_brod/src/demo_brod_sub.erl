%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jan 2019 2:34 PM
%%%-------------------------------------------------------------------
-module(demo_brod_sub).
-author("zhaoweiguo").

-behaviour(brod_group_subscriber).

-include_lib("brod/include/brod.hrl").

%% behabviour callbacks
-export([init/2
    , handle_message/4
]).

-export([message_handler_loop/3]).

-record(callback_state,
{handlers = [] :: [{{brod:topic(), brod:partition()}, pid()}]
    , message_type = message :: message | message_set
}).


%% @doc Initialize nothing in our case.
init(_GroupId, _CallbackInitArg = {ClientId, Topics, MessageType}) ->
    %% For demo, spawn one message handler per topic-partition.
    %% Depending on the use case:
    %% It might be enough to handle the message locally in the subscriber
    %% pid without dispatching to handlers. (e.g. brod_demo_group_subscriber_loc)
    %% Or there could be a pool of handlers if the messages can be processed
    %% in arbitrary order.
    Handlers = spawn_message_handlers(ClientId, Topics),
    {ok, #callback_state{handlers = Handlers, message_type = MessageType}}.



%% @doc Handle one message or a message-set.
handle_message(Topic, Partition, #kafka_message{} = Message,
    #callback_state{handlers = Handlers, message_type = message} = State) ->
    process_message(Topic, Partition, Handlers, Message),
    %% or return {ok, ack, State} in case the message can be handled
    %% synchronously here without dispatching to a worker
    {ok, State};
handle_message(Topic, Partition, #kafka_message_set{messages = Messages} = _MessageSet,
    #callback_state{handlers = Handlers, message_type = message_set} = State) ->
    [process_message(Topic, Partition, Handlers, Message) || Message <- Messages],
    {ok, State}.

%%====================================================================
%% Internal functions
%%====================================================================



%% @private Spawn one message handler per partition. Some of them may sit
%% idle if the partition is assigned to another group member.
%% Perhaps hibernate if idle for certain minutes.
%% Or even spawn dynamically in `handle_message` callback and
%% `exit(normal)` when idle for long.
%% @end
-spec spawn_message_handlers(brod:client_id(), [brod:topic()]) ->
    [{{brod:topic(), brod:partition()}, pid()}].
spawn_message_handlers(_ClientId, []) -> [];
spawn_message_handlers(ClientId, [Topic | Rest]) ->
    {ok, PartitionCount} = brod:get_partitions_count(ClientId, Topic),
    [{{Topic, Partition},
        spawn_link(?MODULE, message_handler_loop, [Topic, Partition, self()])}
        || Partition <- lists:seq(0, PartitionCount - 1)] ++
    spawn_message_handlers(ClientId, Rest).


message_handler_loop(Topic, Partition, SubscriberPid) ->
    receive
        #kafka_message{offset = Offset, value = Value} ->
            lager:info("~s-~p: offset:~w value:~p", [Topic, Partition, Offset, Value]),
            %% @todo
            %% 1.多个节点subscribe时,每个node得到的是同样的,还是不同样的?
            %% 2.保证至少1次,还是至多1次?
            %% 3.send/1是否用新进程?
            brod_group_subscriber:ack(SubscriberPid, Topic, Partition, Offset),
            ?MODULE:message_handler_loop(Topic, Partition, SubscriberPid)
    after 1000 ->
        lager:info("~s-~p: wait timeout", [Topic, Partition]),
        ?MODULE:message_handler_loop(Topic, Partition, SubscriberPid)
    end.


process_message(Topic, Partition, Handlers, Message) ->
    %% send to a worker process
    {_, Pid} = lists:keyfind({Topic, Partition}, 1, Handlers),
    Pid ! Message.
