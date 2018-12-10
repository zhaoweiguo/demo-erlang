%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dec 2018 4:16 PM
%%%-------------------------------------------------------------------
-module(demo_cowboy_worker).
-author("zhaoweiguo").

%% API
-export([send_msg/2]).
-export([send_msg_demo/2]).


send_msg(Msg, Pid) ->
  ok.

send_msg_demo(Msg, Pid) ->
  Pid ! Msg,
  Msg.




