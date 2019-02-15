%%%-------------------------------------------------------------------
%% @doc demo_gun top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(demo_gun_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-include_lib("gutils/include/gutil.hrl").

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
    Ledong = ?CHILD(demo_gun_sockledong_sup, supervisor),
    Client = ?CHILD(demo_gun_sockclient_sup, supervisor),
    Hub = ?CHILD(demo_gun_sockhub_sup, supervisor),
    {ok, { {one_for_all, 0, 1}, [Ledong, Client, Hub]} }.

%%====================================================================
%% Internal functions
%%====================================================================
