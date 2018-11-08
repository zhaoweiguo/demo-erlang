-module(demo_lager).
-export([start/0, start_deps/0]).

start() ->
  start_deps(),
  ensure_started(demo_erlang).

start_deps() ->
  %% 核心库
  ensure_started(crypto),
  ensure_started(asn1),
  ensure_started(public_key),
  ensure_started(ssl),
  ensure_started(compiler),
  ensure_started(syntax_tools),

  %% lager相关
  ensure_started(goldrush),
  ensure_started(lager),

  ok.




%%====================================================================
%% Internal functions
%%====================================================================

ensure_started(App) ->
%    error_logger:info_msg("~p:ensure_started ~p App= ~p ~n", [?MODULE, ?LINE, App]),
%    io:format("~p:ensure_started ~p App= ~p ~n", [?MODULE, ?LINE, App]),
  case application:ensure_all_started(App) of
    {ok, _} ->
      ok;
    {error, {already_started, App}} ->
      ok;
    Error ->
      io:format("~p:ensure_started ~p App= ~p, Error=~p ~n", [?MODULE, ?LINE, App, Error]),
      error_logger:info_msg("~p:ensure_started ~p App= ~p, Error=~p ~n", [?MODULE, ?LINE, App, Error])
  end.
