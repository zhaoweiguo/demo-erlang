%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 七月 2018 下午12:44
%%%-------------------------------------------------------------------
-module(demo_top_tmp).
-author("zhaoweiguo").

%% API
-export([decompile/1]).
-export([pstack/1]).
-export([etop/0, etop_mem/0, etop_stop/0]).
-export([fprof/3]).
-export([eprof_all/1]).
-export([scheduler_usage/0]).
-export([scheduler_stat/0]).
-export([trace/1, trace/2, trace_stop/0]).
-export([proc_mem_all/1, proc_mem/1, proc_mem/2]).
-export([other/0]).
-export([my_port_info/2, my_process_info/2]).
-export([my_sys/2]).

%% 确认线上运行代码是否正确
decompile(Mod) ->
  {ok,{_,[{abstract_code,{_,AC}}]}} = beam_lib:chunks(code:which(Mod), [abstract_code]),
  io:format("~s~n", [erl_prettypr:format(erl_syntax:form_list(AC))]).


%% 类似于jstack，发现大量进程挂起，进程数过高，运行慢，hang住等问题用到
pstack(Reg) when is_atom(Reg) ->
  case whereis(Reg) of
    undefined -> undefined;
    Pid -> pstack(Pid)
  end;
pstack(Pid) ->
  io:format("~s~n", [element(2, process_info(Pid, backtrace))]).

%% 分析内存、cpu占用进程，即使数十w进程node 也能正常使用
%进程CPU占用排名
etop() ->
  spawn(fun() -> etop:start([{output, text}, {interval, 10}, {lines, 20}, {sort, reductions}]) end).

%进程Mem占用排名
etop_mem() ->
  spawn(fun() -> etop:start([{output, text}, {interval, 10}, {lines, 20}, {sort, memory}]) end).

%停止etop
etop_stop() ->
  etop:stop().


%% 进程内存过高时，看看是内存泄露还是gc不过来
%% 对所有process做gc
gc_all() ->
  [erlang:garbage_collect(Pid) || Pid <- processes()].



% 对MFA 执行分析，会严重减缓运行，建议只对小量业务执行
% 结果:
% fprof 结果比较详细，能够输出热点调用路径
fprof(M, F, A) ->
  fprof:start(),
  fprof:apply(M, F, A),
  fprof:profile(),
  fprof:analyse(),
  fprof:stop().


%% 对整个节点内所有进程执行eprof, eprof 对线上业务有一定影响,慎用!
%% 建议TimeoutSec<10s，且进程数< 1000，否则可能导致节点crash
%% 结果:
%% 输出每个方法实际执行时间（不会累计方法内其他mod调用执行时间）
%% 只能得到mod - Fun 执行次数 执行耗时
eprof_all(TimeoutSec) ->
  eprof(processes() -- [whereis(eprof)], TimeoutSec).

eprof(Pids, TimeoutSec) ->
  eprof:start(),
  eprof:start_profiling(Pids),
  timer:sleep(TimeoutSec),
  eprof:stop_profiling(),
  eprof:analyze(total),
  eprof:stop().

%% 统计下1s每个调度器CPU的实际利用率(因为有spin wait、调度工作, 可能usage 比top显示低很多)
%% Erlang的CPU使用情况是比较难衡量的，由于Erlang虚拟机内部复杂的调度机制，
%% 通过top/htop得到的系统进程级的CPU占用率参考性是有限的，即使一个空闲的Erlang虚拟机，调度线程的忙等也会占用一定的CPU
%% 因此Erlang内部提供了一些更有用的测量参考，通过erlang:statistics(scheduler_wall_time)可以获得调度器钟表时间：
%% 1> erlang:system_flag(scheduler_wall_time, true).
%% false
%% 2> erlang:statistics(scheduler_wall_time).
%% [{{1,166040393363,9269301338549},
%%  {2,40587963468,9269301007667},
%%  {3,725727980,9269301004304},
%%  {4,299688,9269301361357}]
%% 该函数返回[{调度器ID, BusyTime, TotalTime}]，
%% BusyTime是调度器执行进程代码，BIF，NIF，GC等的时间，
%% TotalTime是cheduler_wall_time打开统计以来的总调度器钟表时间，
%% 通常，直观地看BusyTime和TotalTIme的数值没有什么参考意义，
%% 有意义的是BusyTime/TotalTIme，该值越高，说明调度器利用率越高
scheduler_usage() ->
  scheduler_usage(1000).

scheduler_usage(RunMs) ->
  erlang:system_flag(scheduler_wall_time, true),
  Ts0 = lists:sort(erlang:statistics(scheduler_wall_time)),
  timer:sleep(RunMs),
  Ts1 = lists:sort(erlang:statistics(scheduler_wall_time)),
  erlang:system_flag(scheduler_wall_time, false),
  Cores = lists:map(fun({{I, A0, T0}, {I, A1, T1}}) ->
    {I, (A1 - A0) / (T1 - T0)} end, lists:zip(Ts0, Ts1)),
  {A, T} = lists:foldl(
    fun({{_, A0, T0}, {_, A1, T1}}, {Ai,Ti}) ->
      {Ai + (A1 - A0), Ti + (T1 - T0)}
    end,
    {0, 0},
    lists:zip(Ts0, Ts1)
  ),
  Total = A/T,
  io:format("~p~n", [[{total, Total} | Cores]]).



%% 统计下1s内调度进程数量(含义：第一个数字执行进程数量，第二个数字迁移进程数量)
scheduler_stat() ->
  scheduler_stat(1000).

scheduler_stat(RunMs) ->
  erlang:system_flag(scheduling_statistics, enable),
  Ts0 = erlang:system_info(total_scheduling_statistics),
  timer:sleep(RunMs),
  Ts1 = erlang:system_info(total_scheduling_statistics),
  erlang:system_flag(scheduling_statistics, disable),
  lists:map(fun({{Key, In0, Out0}, {Key, In1, Out1}}) ->
    {Key, In1 - In0, Out1 - Out0} end, lists:zip(Ts0, Ts1)).

%% 会把mod 每次调用详细MFA log 下来，args 太大就不好看了
%% trace Mod 所有方法的调用
trace(Mod) ->
  dbg:tracer(),
  dbg:tpl(Mod, '_', []),
  dbg:p(all, c).

%trace Node上指定 Mod 所有方法的调用, 结果将输出到本地shell
trace(Node, Mod) ->
  dbg:tracer(),
  dbg:n(Node),
  dbg:tpl(Mod, '_', []),
  dbg:p(all, c).

%停止trace
trace_stop() ->
  dbg:stop_clear().

%% etop 无法应对10w+ 进程节点, 下面代码就没问题了；找到可疑proc后通过pstack、message_queu_len 排查原因
proc_mem_all(SizeLimitKb) ->
  Procs = [{undefined, Pid} || Pid<- erlang:processes()],
  proc_mem(Procs, SizeLimitKb).

proc_mem(SizeLimitKb) ->
  Procs = [{Name, Pid} || {_, Name, Pid, _} <- release_handler_1:get_supervised_procs(),
    is_process_alive(Pid)],
  proc_mem(Procs, SizeLimitKb).

proc_mem(Procs, SizeLimitKb) ->
  SizeLimit = SizeLimitKb * 1024,
  Fun = fun({Name, Pid}, {Acc, TotalSize}) ->
    case erlang:process_info(Pid, total_heap_size) of
      {_, Size0} ->
        Size = Size0*8,
        case Size > SizeLimit of
          true -> {[{Name, Pid, Size} | Acc], TotalSize+Size};
          false -> {Acc, TotalSize}
        end;
      _ -> {Acc, TotalSize}
    end
        end,
  {R, Total} = lists:foldl(Fun, {[], 0}, Procs),
  R1 = lists:keysort(3, R),
  {Total, lists:reverse(R1)}.


other() ->
  LenProcess = length(processes()),
  LenPort = length(erlang:ports()),
  Rate = LenProcess/LenPort,
  io:format("len process: ~p, len port: ~p, rate: ~p", [LenProcess, LenPort, Rate]).

%% 指定进程的详细信息，都可以通过erlang:process_info(Pid, Key)获得，其中比较有用的Key有
%%  dictionary: 进程字典中所有的数据项
%%  registerd_name: 注册的名字
%%  status: 进程状态
%%  links: 所有链接进程
%%  monitored_by: 所有监控当前进程的进程
%%  monitors: 所有被当前进程监控的进程
%%  trap_exit: 是否捕获exit信号
%%  current_function: 当前进程执行的函数，{M, F, A}
%%  current_location: 进程在模块中的位置，{M, F, A, [{file, FileName}, {line, Num}]}
%%  current_stacktrace: 以current_location的格式列出堆栈跟踪信息
%%  initial_call: 进程初始入口函数，如spawn时的入口函数，{M, F, A}
%%  memory: 进程占用的内存大小(包含所有堆，栈等)，以bytes为单位
%%  message_queue_len: 进程邮箱中的待处理消息个数
%%  messages: 返回进程邮箱中的所有消息，该调用之前务必通过message_queue_len确认消息条数，否则消息过多时，调用非常危险
%%  reductions: 进程规约数
my_process_info(Pid, Key) ->
  erlang:process_info(Pid, Key).

%% 获取端口信息，可调用erlang:port_info/2
my_port_info(Pid, Key) ->
  erlang:port_info(Pid, Key).


%% sys:log_to_file(Pid, FileName)： 将指定进程收到的所有事件信息打印到指定文件
%% sys:get_state(Pid)： 获取OTP进程的State
%% sys:statistics(Pid, Flag): Flag: true/false/get 打开/关闭/获取进程信息统计
%% sys:install/remove 可为指定进程动态挂载和卸载通用事件处理函数
%% sys:suspend/resume: 挂起/恢复指定进程
%% sys:terminate(Pid, Reason): 向指定进程发消息，终止该进程
my_sys(Pid, FileName) ->
  sys:log_to_file(Pid, FileName).














