%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 九月 2018 下午3:33
%%%-------------------------------------------------------------------
-module(ch3).
-author("zhaoweiguo").
-behaviour(gen_server).

-export([start_link/0]).
-export([alloc/0, free/1]).
-export([available/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
  gen_server:start_link({local, ch3}, ch3, [], []).

alloc() ->
  gen_server:call(ch3, alloc).

free(Ch) ->
  gen_server:cast(ch3, {free, Ch}).

available() ->
  gen_server:call(ch3, available).

init(_Args) ->
  {ok, channels()}.

handle_call(alloc, _From, Chs) ->
  {Ch, Chs2} = alloc(Chs),
  {reply, Ch, Chs2};
handle_call(available, _From, Chs) ->
  N = available(Chs),
  {reply, N, Chs}.

handle_cast({free, Ch}, Chs) ->
  Chs2 = free(Ch, Chs),
  {noreply, Chs2}.


handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_Vsn, State, _Extra) ->
  {ok, State}.



%%======inner method=======
available(_Chs) ->
  "chs".
channels() ->
  {_Allocated = [], _Free = lists:seq(1,100)}.

alloc({Allocated, [H|T] = _Free}) ->
  {H, {[H|Allocated], T}}.

free(Ch, {Alloc, Free} = Channels) ->
  case lists:member(Ch, Alloc) of
    true ->
      {lists:delete(Ch, Alloc), [Ch|Free]};
    false ->
      Channels
  end.





