#!/usr/bin/env escript
%% This is an -*- erlang -*- file
%%!-smp disable
%% Demo
main(_Args) ->
    io:format(erlang:system_info(smp_support)).
