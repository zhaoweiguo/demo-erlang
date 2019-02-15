%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. Jan 2019 11:01 AM
%%%-------------------------------------------------------------------
-module(demo_gun_util).
-author("zhaoweiguo").

%% API
-export([get_server_port/1]).

-spec get_server_port(Arg:: client_server | hub_server | ledong_server) ->
    {Host::list(), Port::integer()}.
get_server_port(Tag) ->
    {ok, Server} = application:get_env(demo_gun, Tag),
    Host = proplists:get_value(host, Server, "localhost"),
    Port = proplists:get_value(port, Server, 80),
    {Host, Port}.



