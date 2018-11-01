%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. Nov 2018 5:09 PM
%%%-------------------------------------------------------------------
-module(util_l).
-author("zhaoweiguo").

%% API
-export([log/1, log/2]).


log(Format, Vars) ->
  io:format(Format, Vars),
  io:format("\n").

log(Detail) ->
  io:format(Detail),
  io:format("\n").
