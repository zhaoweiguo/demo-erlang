%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Feb 2019 4:29 PM
%%%-------------------------------------------------------------------
-module(mnesia_delete_object).
-author("zhaoweiguo").


-record(gordon_test, {
    idr,    % {id, pid}
    id,
    pid,
    type,
    locale,
    time = os:timestamp()
}).

%% API
-export([init_tab/0]).
-export([add_datas/0, add_data/3]).

do_action() ->
    Id = 3,
    Pid = 3,

    % 查出id=3的所有记录
    mnesia:dirty_index_read(gordon_test, Id, #gordon_test.id),
    %
    mnesia:dirty_index_match_object(#gordon_test{idr = '$1',id=Id, _='_'}, #gordon_test.id),

    X = #gordon_test{
        idr = {Id, Pid},
        id = Id,
        pid = Pid
    },
    mnesia:dirty_delete_object(X#gordon_test{locale = aaaa}),

    mnesia:dirty_index_read(gordon_test, 3, #gordon_test.id),
    mnesia:dirty_index_match_object(#gordon_test{idr = '$1',id=a, _='_'}, #gordon_test.id),

    Trans = fun() ->
        mnesia:delete_object(X#gordon_test{locale = aaaa})
            end,
    mnesia:transaction(Trans),



        ok.



init_tab() ->
    mnesia:create_schema([node()]),
    case application:ensure_all_started(mnesia) of
        {ok, _} ->
            ok;
        {error, {already_started, App}} ->
            ok;
        Error ->
            io:format("error:~p~n", [Error])
    end,
    mnesia:change_table_copy_type(schema, node(), disc_copies),
    mnesia:create_table(gordon_test, [
        {ram_copies, [node() | nodes()]},
        {attributes, record_info(fields, gordon_test)}
    ]),
    mnesia:add_table_index(gordon_test, id),
    mnesia:add_table_index(gordon_test, pid).


clean_datas() ->
    mnesia:dirty_delete(#gordon_test{}).

add_datas() ->
    add_data(10, 100, 1).

add_data(0, _, _) ->
    io:format("done~n"),
    done;
add_data(Num, Id, Id) ->
    Pid = Num,
    add_data1(Id, Pid),
    add_data(Num-1, Id, 1);
add_data(Num, Step, Id) ->
    Pid = Num,
    add_data1(Id, Pid),
    add_data(Num, Step, Id+1).

add_data1(Id, Pid) ->
    mnesia:dirty_write(gordon_test, {gordon_test, {Id, Pid}, Id, Pid, "", "", os:timestamp()}).




