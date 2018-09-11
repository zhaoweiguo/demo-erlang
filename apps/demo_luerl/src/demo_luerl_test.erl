%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 九月 2018 下午4:59
%%%-------------------------------------------------------------------
-module(demo_luerl_test).
-author("zhaoweiguo").

%% API
-export([test1/0, test2/0, test3/0]).



test1() ->
  St0 = luerl:init(),
  St1 = luerl:set_table([math], <<"no math for you!">>, St0),
  luerl:eval("return math", St1).


test2() ->
  luerl:do("print(\"Hello, Robert!\")").

test3() ->
  EmptyState = luerl:init(),
  {ok, Chunk, State} = luerl:load("print(\"Hello, Chunk!\")", EmptyState),
  {_Ret, _NewState} = luerl:do(Chunk, State).






