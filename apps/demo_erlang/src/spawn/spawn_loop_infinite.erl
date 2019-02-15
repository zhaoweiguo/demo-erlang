%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%     测试无限的spawn进程，会有什么情况
%%% @end
%%% Created : 15. Feb 2019 6:16 PM
%%%-------------------------------------------------------------------
-module(spawn_loop_infinite).
-author("zhaoweiguo").

%% API
-export([loop/0]).
-export([do_nothing/0]).


loop() ->
    loop(1000),
    io:format("-"),
    timer:sleep(100),
    loop().


loop(0) ->
    ok;
loop(N) ->
    spawn(spawn_loop_infinite, do_nothing, []),
    loop(N-1).


do_nothing() ->
    ok.


