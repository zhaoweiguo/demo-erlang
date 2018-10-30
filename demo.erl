%% demo.erl
-module(demo).
-export([main/1]).

%% Demo
main(_Args) ->
    io:format(erlang:system_info(smp_support)).
