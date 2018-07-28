%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 七月 2018 下午1:30
%%%-------------------------------------------------------------------
-module(demo_lager_tmp).
-author("zhaoweiguo").

%% API
-export([start/0,test/1]).


start() ->
  lager:info("start lager ......"),
  application:ensure_all_started(lager).

test(Num)->
  F = fun(_Num,Acc)->
    supervisor:start_child(demo_lager_sup,[]),
    1+Acc
      end,
  lists:foldl(F,0,lists:seq(1,10000)).

test(Num)->
  F = fun(_Num,Acc)->
    spwan(demo_lager_sup,[]),
    1+Acc
      end,
  lists:foldl(F,0,lists:seq(1,10000)).


