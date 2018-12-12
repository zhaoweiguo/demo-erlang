%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dec 2018 4:38 PM
%%%-------------------------------------------------------------------
-module(demo_cowboy_servers).
-author("zhaoweiguo").

-behaviour(gen_server).

-include_lib("gutils/include/gutil.hrl").

%% API
-export([start_link/0, start_link/1]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
start_link({Server, Num}) ->
  ?LOGLN(""),
  ?LOGF("server:~p~n", [Server]),
  gen_server:start_link({local, {?SERVER, Num}}, ?MODULE, [Server], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================


init([Server]) ->
  ?LOGF("server:~p~n", [Server]),
  {ok, #state{}}.


handle_call(_Request, _From, State) ->
  {reply, ok, State}.


handle_cast(_Request, State) ->
  {noreply, State}.


handle_info(_Info, State) ->
  {noreply, State}.


terminate(_Reason, _State) ->
  ok.


code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
