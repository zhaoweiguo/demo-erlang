%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Oct 2018 3:12 PM
%%%-------------------------------------------------------------------
-module(demo_clique_cli).
-author("zhaoweiguo").
-behaviour(clique_handler).

%% API
-export([register_cli/0]).

register_cli() ->
  register_cli_usage(),
  status_cmd().

status_cmd() ->
  Cmd = ["vmq-admin", "webhooks", "status"],
  Callback =
    fun(_, [], []) ->
      Table =
        [],
      [clique_status:table(Table)];
      (_, _, _) ->
        Text = clique_status:text(webhooks_usage()),
        [clique_status:alert([Text])]
    end,
  clique:register_command(Cmd, [], [], Callback).



register_cli_usage() ->
  clique:register_usage(["vmq-admin", "webhooks"], webhooks_usage()).

webhooks_usage() ->
  ["demo_clique webhooks <sub-command>\n\n",
    "  Manage VerneMQ Webhooks.\n\n",
    "  Sub-commands:\n",
    "    status      Show the status of registered webhooks\n",
    "    register    Register a webhook\n",
    "    deregister  Deregister a webhook\n",
    "    cache       Manage the webhooks cache\n\n",
    "  Use --help after a sub-command for more details.\n"
  ].
