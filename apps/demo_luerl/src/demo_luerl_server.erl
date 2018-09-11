%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 九月 2018 上午10:28
%%%-------------------------------------------------------------------
-module(demo_luerl_server).
-author("zhaoweiguo").

%% API
-export([translate/0,translate/1]).
-export([translate_simple/0]).



translate()->
  % 1read input1.json
  FileJsonPath = "luas/input1.json",
  {ok, FileJson} = file:open(FileJsonPath, [read]),
  {ok, Json} = file:read(FileJson, filelib:file_size(FileJsonPath)),
  io:format("1param: ~p~n", [Json]),
  BinJson = list_to_binary(Json),
  translate(BinJson),
  ok.

translate(Json) when is_list(Json)->
  translate(list_to_binary(Json));
translate(BinJson) when is_binary(BinJson)->

  State0 = luerl:init(),
  % 2.1read do1.lua
  FilePath = "./luas/do1.lua",
  {ok, File} = file:open(FilePath, read),
  {ok, Content} = file:read(File, filelib:file_size(FilePath)),

  % 2.2load do1.lua
  {_Result,State2} = luerl:do(Content, State0),

  %4 call function
  {Result, _} = luerl:call_function([doit], [BinJson], State2),
  io:format("Result: ~p~n", [Result]),
  ok.






translate1()->
  % 1read input1.json
  FileJsonPath = "luas/input1.json",
  {ok, FileJson} = file:open(FileJsonPath, [read]),
  {ok, Json} = file:read(FileJson, filelib:file_size(FileJsonPath)),
  io:format("1param: ~p~n", [Json]),

  % 3.1read json.lua
  FileJsonLuaPath= "luas/json.lua",
  io:format("2jsonluapath:~p~n", [FileJsonLuaPath]),
  {ok, FileJsonLua} = file:open(FileJsonLuaPath, [read]),
  {ok, JsonLuaContent} = file:read(FileJsonLua, filelib:file_size(FileJsonLuaPath)),
%%  io:format("3jsonlua:~p~n", [JsonLuaContent]),

  State0 = luerl:init(),


  % 2.1read do1.lua
  FilePath = "./luas/do1.lua",
  {ok, File} = file:open(FilePath, read),
  {ok, Content} = file:read(File, filelib:file_size(FilePath)),

  % 2.2load do1.lua
  {ok,Chunk1,State1} = luerl:load(Content, State0),
  {_Result,State2} = luerl:do(Chunk1, State1),

%%  {_Result,State4} = luerl:do(Chunk3, State3),

  %4 call function
  {Result, _} = luerl:call_function([doit], [Json], State2),
  io:format("Result: ~p~n", [Result]),
  ok.




translate_simple()->
  FileJsonPath = "luas/input1.json",
  {ok, FileJson} = file:open(FileJsonPath, [read]),
  {ok, Json} = file:read(FileJson, filelib:file_size(FileJsonPath)),
  io:format("1param: ~p~n", [Json]),

  % 2.1read do1.lua
  FilePath = "./luas/do_simple.lua",
  {ok, File} = file:open(FilePath, read),
  {ok, Content} = file:read(File, filelib:file_size(FilePath)),

  State0 = luerl:init(),
  % 2.2load do1.lua
%%  {ok,Chunk1,State1} = luerl:load(Content, State0),
%%  {_Result,State2} = luerl:do(Chunk1, State1),
  {_Result,State2} = luerl:do(Content, State0),

  %4 call function
  {Result, _} = luerl:call_function([doit], [Json], State2),
  io:format("Result: ~p~n", [Result]),
  ok.


translate1(BinJson) when is_list(BinJson)->
  io:format("param: ~p~n", [BinJson]),
  FilePath = "./do1.lua",
  {ok, File} = file:open(FilePath, read),
  {ok, Content} = file:read(File, filelib:file_size(FilePath)),
  State0 = luerl:init(),
  {ok,Chunk,State1} = luerl:load(Content, State0),
  {_Result,State2} = luerl:do(Chunk, State1),
  {Result, _} = luerl:call_function([doit], [BinJson], State2),
  io:format("Result: ~p~n", [Result]),
  ok.



