%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dec 2018 4:56 PM
%%%-------------------------------------------------------------------
-module(demo_cowboy_servers_sup).
-author("zhaoweiguo").

-behaviour(supervisor).

-include_lib("gutils/include/gutil.hrl").

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
  {ok, {SupFlags :: {RestartStrategy :: supervisor:strategy(),
    MaxR :: non_neg_integer(), MaxT :: non_neg_integer()},
    [ChildSpec :: supervisor:child_spec()]
  }} |
  ignore |
  {error, Reason :: term()}).
init([]) ->

  SupFlags = {one_for_one, 1000, 3600},

  {ok, Servers} = application:get_env(servers),

  Children = gen_children(Servers),
  ?LOGF("children:~p~n", [Children]),

  {ok, {SupFlags, Children}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

gen_children(Servers) ->
  gen_children(Servers, 1, []).

gen_children([], _, Children) ->
  Children;
gen_children([Server | Other], Num, Children) ->
  I = demo_cowboy_servers,
  Child = {{I, Num}, {I, start_link, [{Server, Num}]}, permanent, 5000, worker, [I]},
  gen_children(Other, Num+1, [Child | Children]).

