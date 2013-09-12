-module(commandBus_svr).

-behaviour(gen_server).

-export([start_link/0, registerHandler/2, dispatch/2]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%%% Client functions
start_link() -> 
	{_,Pid} = gen_server:start_link(?MODULE, [], []),
	register(?MODULE, Pid).

registerHandler(Command, CommandHandler) ->
	gen_server:call(?MODULE, {register, Command, CommandHandler}).

dispatch(Command, CommandData) ->
	gen_server:call(?MODULE, {dispatch, Command, CommandData}).

%%% Server functions
init([]) -> 	
	{ok, orddict:new()}. % init state

handle_call({register, Command, CommandHandler}, _From, State) ->
	NewState = orddict:store(Command,CommandHandler,State),
	{reply, ok, NewState};
handle_call({dispatch, Command, CommandData}, _From, State) ->
    {ok, CommandHandler} = orddict:find(Command, State),
    CommandHandler:handle(Command, CommandData),
    {reply, ok, State};
handle_call(Msg, _From, State) ->
	io:format("Unexpected message: ~p~n",[Msg]),
	{stop, normal, State}.
 
handle_cast(Msg, State) ->
	io:format("Unexpected message: ~p~n",[Msg]),
	{stop, normal, State}.

handle_info(Msg, State) ->
	io:format("Unexpected message: ~p~n",[Msg]),
	{stop, normal, State}.

terminate(_Msg, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	%% No change planned. The function is there for the behaviour,
	%% but will not be used. Only a version on the next
	{ok, State}.

