%%%-------------------------------------------------------------------
%% @doc demo_coap top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(demo_coap_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

-include_lib("gutils/include/gutil.hrl").

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    ?LOGLN(""),
%%    application:ensure_all_started(gen_coap),
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: #{id => Id, start => {M, F, A}}
%% Optional keys are restart, shutdown, type, modules.
%% Before OTP 18 tuples must be used to specify a child. e.g.
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    ?LOGLN(""),
    {ok, { {one_for_all, 0, 1}, [
%%        ?CHILD(demo_coap_server, worker)
    ]} }.

%%====================================================================
%% Internal functions
%%====================================================================
