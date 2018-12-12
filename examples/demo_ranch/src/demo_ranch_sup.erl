%%%-------------------------------------------------------------------
%% @doc demo_ranch top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(demo_ranch_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: #{id => Id, start => {M, F, A}}
%% Optional keys are restart, shutdown, type, modules.
%% Before OTP 18 tuples must be used to specify a child. e.g.
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
%%  ok = application:start(ranch),
  {ok, _} = ranch:start_listener(tcp_demo_ranch,
    ranch_tcp, [
      {port, 5556},             % port=0,时使用随机端口>1024
      {max_connections, 100},   % 最大连接数,默认1024,可用infinity
      {num_acceptors, 42}       % 默认为10
    ],
    demo_ranch_protocol, []
  ),
  {ok, {{one_for_all, 0, 1}, []}}.

%%====================================================================
%% Internal functions
%%====================================================================
