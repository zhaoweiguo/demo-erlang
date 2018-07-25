%%%-------------------------------------------------------------------
%% @doc demo_lager top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(demo_lager_sup).

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
    RestartStrategy = simple_one_for_one,
    MaxRestarts = 1000, %
    MaxSecondsBetweenRestarts = 3600,   %

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = temporary,
    Shutdown = 2000,   % brutal_kill
    Type = worker,

    TestClient = {demo_lager_server, {demo_lager_server, start_link, []},
        Restart, Shutdown, Type, [demo_lager_server]},
    {ok, {SupFlags, [TestClient]}}.



%%====================================================================
%% Internal functions
%%====================================================================
