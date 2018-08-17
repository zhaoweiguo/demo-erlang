%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 八月 2018 下午6:29
%%%-------------------------------------------------------------------
-module(demo_mqtt_tmp).
-author("zhaoweiguo").

%% API
-export([connect/2, sub/2, pub/3]).

-export([test/0, test/2]).

test() ->
  test("223.202.212.28", <<"cliendid">>).

test(Ip, ClientId)->
  C = connect(Ip, ClientId),
  sub(C, ClientId),
  pub(C, ClientId, <<"payload">>),

  receive
    {publish, Topic, Payload} ->
      io:format("Message Received from ~s: ~p~n", [Topic, Payload]);
    Msg ->
      io:format("Msg: ~p~n", [Msg])

  after
    1000 ->
      io:format("Error: receive timeout!~n")
  end,


%% disconnect from broker
%%  emqttc:disconnect(C).
  ok.



%%%------- interal ---------

connect(Host, ClientId) ->
  {ok, C} = emqttc:start_link([{host, Host}, {client_id, ClientId}]),
  C.

sub(C, Topic) ->
  emqttc:subscribe(C, Topic, qos0),
  ok.

pub(C, Topic, Payload) ->
  emqttc:publish(C, Topic, Payload),
  ok.





