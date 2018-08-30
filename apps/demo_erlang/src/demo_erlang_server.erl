%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 八月 2018 下午6:18
%%%-------------------------------------------------------------------
-module(demo_erlang_server).
-author("zhaoweiguo").

-behaviour(gen_server).
%% API

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).



-record(state, {}).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  {ok, #state{
  }}.


handle_call(_Req, _From, State) ->
  {reply, {error, badrequest}, State}.

handle_cast(_Req, State) ->
  {noreply, State}.

handle_info(Info, State) ->
  error_logger:warning_msg("unknow info ~p~n", [Info]),
  {noreply, State}.


terminate(_Reason, State) ->
  ok.


code_change(_Vsn, State, _Extra) ->
  {ok, State}.
