%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jan 2019 2:35 PM
%%%-------------------------------------------------------------------
-module(demo_brod_pub).
-author("zhaoweiguo").
-include("demo_brod.hrl").

%% API
-export([do/0]).

do() ->
    Msg = "1111",
    PartitionFun = fun(_Topic, Partition, _Key, _Value) ->
        {ok, crypto:rand_uniform(0, Partition)}
                   end,
    TestProducerTopic = oct_nbiot_util:get_consumer_topic(),
    case brod:produce_sync(?CLIENT_ID, TestProducerTopic, PartitionFun, <<"">>, Msg) of
        ok ->
            ok;
        {error, Reason} ->
            % @todo send warning sms?
            lager:error("kafka error:~p", [Reason])
    end.