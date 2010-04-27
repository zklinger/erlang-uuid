%%% ***************************************************************************
%%%
%%% A UUID generator using a linked-in driver
%%%
%%% Copyright 2010 Zoltan Klinger <zoltan dot klinger at gmail dot com>
%%%
%%% This program is free software: you can redistribute it and/or modify 
%%% it under the terms of the GNU General Public License as published by 
%%% the Free Software Foundation, either version 3 of the License, or 
%%% (at your option) any later version. 
%%% 
%%% This program is distributed in the hope that it will be useful, 
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of 
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
%%% GNU General Public License for more details. 
%%% 
%%% You should have received a copy of the GNU General Public License 
%%% along with this program. If not, see <http://www.gnu.org/licenses/>. 
%%%
%%% ***************************************************************************

-module(uuid).

-behavior(gen_server).

-define(CMD_NEXT, [0]).
-define(CMD_NEXT_T, [1]).
-record(state, {port}).

-export([start_link/2, stop/0]).
-export([create/0, create_t/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3,
         terminate/2]).


%%% ===========================================================================
%%% API functions
%%% ===========================================================================
%% ---------------------------------------------------------------------------
%% start_link
%% ---------------------------------------------------------------------------
start_link(DrvPath, DrvName) ->
gen_server:start_link({local, ?MODULE}, ?MODULE, [DrvPath, DrvName ], []).

%% ---------------------------------------------------------------------------
%% stop
%% ---------------------------------------------------------------------------
stop() -> gen_server:call(?MODULE, stop).

%% ---------------------------------------------------------------------------
%% Function: create() -> {ok, string()} |
%%                       false
%% Description: Create a random number based on random values
%% ---------------------------------------------------------------------------
create() -> gen_server:call(?MODULE, {generate, port_cmd_next()}).

%% ---------------------------------------------------------------------------
%% Function: create_t() -> {ok, string()} |
%%                         false
%% Description: Create a random number based on time and MAC address values
%% ---------------------------------------------------------------------------
create_t() -> gen_server:call(?MODULE, {generate, port_cmd_next_t()}).


%%% ===========================================================================
%%% Callback functions
%%% ===========================================================================
%% ---------------------------------------------------------------------------
%% init
%% ---------------------------------------------------------------------------
init([DrvPath, DrvName]) ->
  process_flag(trap_exit, true),
  case erl_ddll:load_driver(DrvPath, DrvName) of 
    Res when Res =:= ok ; Res =:= {error, already_loaded} -> 
      Port = open_port({spawn, DrvName}, []),
      {ok, #state{port = Port}};
    _Other -> {stop, {error, could_not_load_driver}} 
  end. 

%% ---------------------------------------------------------------------------
%% handle_call
%% ---------------------------------------------------------------------------
handle_call({generate, PortCmdData}, _From, #state{port=Port} = State) ->
  port_command(Port, PortCmdData), 
  case collect_response(Port) of
    {response, Response} -> 
      {reply, Response, State};
    timeout -> 
      {stop, port_timeout, State}
  end;
handle_call(stop, _From, State) ->
    {stop, normal, stopped, State}.


%% ---------------------------------------------------------------------------
%% handle_info
%% ---------------------------------------------------------------------------
handle_info({'EXIT', Port, Reason}, #state{port = Port} = State) ->
  {stop, {port_terminated, Reason}, State}.

%% ---------------------------------------------------------------------------
%% terminate
%% ---------------------------------------------------------------------------
terminate({port_terminated, _Reason}, _State) ->
  ok;
terminate(_Reason, #state{port = Port} = _State) ->
  port_close(Port).

%% ---------------------------------------------------------------------------
%% Others
%% ---------------------------------------------------------------------------
handle_cast(_Msg, State) ->
  {noreply, State}.
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

  
%%% ===========================================================================
%%% Internal functions
%%% ===========================================================================
%% ---------------------------------------------------------------------------
%% collect_response
%% ---------------------------------------------------------------------------
collect_response(Port) ->
  receive
		{Port, {data, Data}} -> decode(Data)
  end.

%% ---------------------------------------------------------------------------
%% port command data
%% ---------------------------------------------------------------------------
port_cmd_next()   -> [0].
port_cmd_next_t() -> [1].

%% ---------------------------------------------------------------------------
%% decode port response
%% ---------------------------------------------------------------------------
decode("false") -> {response, false};
decode(Value) -> {response, {ok, Value}}.


