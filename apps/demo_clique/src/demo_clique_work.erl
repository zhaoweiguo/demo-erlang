%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Oct 2018 6:02 PM
%%%-------------------------------------------------------------------
-module(demo_clique_work).
-author("zhaoweiguo").

%% API
-export([register_cli/0, set_transfer_limit/2, load_schema/0]).
-behaviour(clique_handler).

-export([command/1]).

-spec command([string()]) -> ok.
command(Cmd) ->
  application:start(clique),
  F = fun() ->
        ok
      end,
  clique:register_node_finder(F),
  load_schema(),
  %% Example Cmd = ["riak-admin", "handoff"]
  %% This is the way arguments get passed in from a shell script using Nodetool.
  %% They are passed into an escript main/1 function in the same manner, but
  %% without the script name.
  clique:run(Cmd).

load_schema() ->
  case application:get_env(schema_dirs) of
    {ok, Directories} ->
      ok = clique_config:load_schema(Directories);
    _ ->
      ok = clique_config:load_schema([code:lib_dir()])
  end.


-spec set_transfer_limit(Key :: [string()], Val :: string()) -> Result :: string().
set_transfer_limit(Key, Val) ->
  ok.

register_cli() ->
  Key = ["transfer_limit"],
  Callback = fun set_transfer_limit/2,
  clique:register_config(Key, Callback),


    Cmd = ["riak-admin", "handoff", "limit"],

    KeySpecs = [],
    FlagSpecs = [ {node, [{shortname, "n"},
                  {longname, "node"},
                  {typecast, fun clique_typecast:to_node/1}]}],

    Callback = fun(["riak-admin", "handoff", "limit"]=_Cmd, []=_Keys, [{node, Node}]=_Flags) ->
        case clique_nodes:safe_rpc(Node, somemod, somefun, []) of
            {error, _} ->
              Text = clique_status:text("Failed to Do Something"),
              [clique_status:alert([Text])];
            {badrpc, _} ->
              Text = clique_status:text("Failed to Do Something"),
              [clique_status:alert([Text])];
            Val ->
              Text = io_lib:format("Some Thing was done. Value = ~p~n", [Val]),
              [clique_status:text(Text)]
        end
               end,

    clique:register_command(Cmd, KeySpecs, FlagSpecs, Callback).

