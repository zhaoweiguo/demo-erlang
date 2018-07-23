%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%   lager入口
%%% @end
%%% Created : 23. 七月 2018 下午6:30
%%%-------------------------------------------------------------------
-module(mylager).
-author("zhaoweiguo").

%% API
-export([init/0]).

init() ->
  lager:error("Some message"),
  Term = "------------",
  lager:warning("Some message with a term: ~p", [Term]),

  ok.



