%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%     测试无限的spawn进程，会有什么情况
%%% @cmd
%%%     运行:erl> spawn_loop_infinite:loop(10000, 0).
%%% @end
%%% Created : 15. Feb 2019 6:16 PM
%%%-------------------------------------------------------------------
-module(spawn_loop_infinite).
-author("zhaoweiguo").

%% API
-export([loop/2]).
-export([do_nothing/0]).

loop(N, N) ->
    io:format("stop~n");
loop(M, N) ->
    Add = 32768*10,
    io:format("~p;", [N]),
    {ok, F} = file:open("fff"++ integer_to_list(N) ++".txt", [append]),
    loop1(Add, N, F),
    file:close(F),
    timer:sleep(10),
    loop(M, N+1).


loop1(0, _N, _F) ->
    ok;
loop1(Add, N, F) ->
    Pid = spawn(spawn_loop_infinite, do_nothing, []),
    file:write(F, io_lib:format("[~p]:(~p)~n", [Add, Pid])),
    loop1(Add-1, N, F).


do_nothing() ->
    ok.
