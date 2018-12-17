%%%-------------------------------------------------------------------
%% @doc demo_tcp top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(demo_tcp_sup).

-behaviour(supervisor).

-include_lib("gutils/include/gutil.hrl").

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
    Port = 5556,
    {ok, Socket} = gen_tcp:connect("localhost", Port, [{active, once}, {packet, 0}]),
%%    {ok, Socket} = gen_tcp:connect("localhost", Port, [{active, false}, {packet, 0}], 5000),
    gen_tcp:send(Socket, <<"1234567890\r\n">>),
    A = gen_tcp:recv(Socket,0),
    ?LOGF("receive:~p~n", [A]),
    gen_tcp:close(Socket),
    {ok, { {one_for_all, 0, 1}, []} }.

%%====================================================================
%% Internal functions
%%====================================================================
