%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Mar 2019 5:18 PM
%%%-------------------------------------------------------------------
-module(spawn_link_trap_exit).
-author("zhaoweiguo").

%% API
-export([do_it/0]).
-export([do_it2/0]).
-export([do_exit/0]).


do_it() ->
    process_flag(trap_exit, true),
    io:format("Pid:~p~n", [self()]),
    Pid = erlang:spawn_link(timer, sleep, [10000000000]),
    io:format("Pid:~p~n", [Pid]),
    exit(Pid, kill),
    receive
        {'EXIT', Pid, killed} ->
            io:format("ok")
    end.



do_it2() ->
    process_flag(trap_exit, true),
    Pid = erlang:spawn_link(spawn_link_trap_exit, do_exit, []),
    io:format("Pid:~p~n", [Pid]),
    receive
        {'EXIT', Pid, killed} ->
            io:format("ok");
        {'EXIT', Pid, Reason} ->
            io:format("Msg:~p~n", [Reason])
    end.


do_exit() ->
    1=2.
