%%%-------------------------------------------------------------------
%% @doc mongo 测试代码
%% @end
%%%-------------------------------------------------------------------

-module(mongo_gadget_type_info).

%% Application callbacks
-export([start/2, start2/2]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
  Database = <<"octopus">>,
  Collection = <<"gadget_type_info">>,
  {ok, Connection} = mc_worker_api:connect([{database, Database}]),

  Fun = fun() ->
    mc_worker_api:find(Connection, Collection, #{<<"type_id">> => <<"1000003">>})
  end,
  lists:foreach(Fun, lists:seq(1, 100)).



start2(_StartType, _StartArgs) ->
  Database = <<"octopus">>,
  Collection = <<"gadget_type_info">>,
  {ok, Connection} = mc_worker_api:connect ([{database, Database}]),

  Fun = fun() ->
    mc_worker_api:find(Connection, Collection, #{})
  end,
  lists:foreach(Fun, lists:seq(1, 100)).

%%====================================================================
%% Internal functions
%%====================================================================
