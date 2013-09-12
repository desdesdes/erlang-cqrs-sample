-module(eventBus_svr).

-behaviour(gen_server).

-export([start_link/0, registerHandler/2, publish/2]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%%% Client functions
start_link() -> 
	{_,Pid} = gen_server:start_link(?MODULE, [], []),
	register(?MODULE, Pid).

registerHandler(Event, EventHandler) ->
	gen_server:call(?MODULE, {register, Event, EventHandler}).

publish(Event, EventData) ->
	gen_server:call(?MODULE, {publish, Event, EventData}).

%%% Server functions
init([]) -> 	
	{ok, orddict:new()}. % init state

handle_call({register, Event, EventHandler}, _From, State) ->
	NewState = addDestination(State, Event,EventHandler),
	{reply, ok, NewState};
handle_call({publish, Event, EventData}, _From, State) ->
	case orddict:find(Event, State) of
		{ok, CurrentHandlers} ->
			callDestination(CurrentHandlers, Event, EventData);
		error ->
			ok
    end,
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

addDestination(CurrentDestinations, Event, EventHandler) -> 
	case orddict:find(Event, CurrentDestinations) of
		{ok, CurrentHandlers} ->
			NewHandlers = [EventHandler | CurrentHandlers],
			orddict:store(Event, NewHandlers, CurrentDestinations);
		error ->
			orddict:store(Event, [EventHandler], CurrentDestinations)
    end.

callDestination([], _Event, _EventData) -> 
    ok;
callDestination([EventHandler|T], Event, EventData) -> 
	io:format("callDestination: ~p~n",[EventHandler]),
	EventHandler:handle(Event, EventData),
	callDestination(T, Event, EventData).