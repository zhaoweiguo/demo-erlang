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

-define(FLAG, false).

%% API
-export([log/1, log/2]).


log(Format, Vars) ->
  if
    ?FLAG ==true ->
      io:format(Format, Vars),
      io:format("\n");
    true ->
      ok
  end.


log(Detail) ->
  if
    ?FLAG ->
      io:format(Detail),
      io:format("\n");
    true ->
      ok
  end.

