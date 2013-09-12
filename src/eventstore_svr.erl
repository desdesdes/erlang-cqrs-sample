-module(eventstore_svr).

-behaviour(gen_server).

-export([start_link/0, storeNew/2, storeAdd/2, retrieve/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%%% Client functions
start_link() -> 
	{_,Pid} = gen_server:start_link(?MODULE, [], []),
	register(?MODULE, Pid).

storeNew(Id, Events) ->
	gen_server:call(?MODULE, {storeNew, Id, Events}).

storeAdd(Id, Events) ->
	gen_server:call(?MODULE, {storeAdd, Id, Events}).

retrieve(Id) ->
	gen_server:call(?MODULE, {retrieve, Id}).

%%% Server functions
init([]) -> 	
	{ok, orddict:new()}. % init state

handle_call({storeAdd, Id, Events}, _From, State) ->
	NewState = addEventsToExisting(Id, Events, State),
	{reply, ok, NewState};
handle_call({storeNew, Id, Events}, _From, State) ->
	NewState = addEventsToNew(Id, Events, State),
	{reply, ok, NewState};
handle_call( {retrieve, Id}, _From, State) ->
    {reply, getEvents(Id, State), State};
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

addEventsToNew(Id, Events, State) -> 
	case orddict:find(Id, State) of
		{ok, CurrentEvents} ->
			io:format("Unexpected addEventsToNew: ~p~n",[CurrentEvents]),
			throw(commandException);
		error ->
			orddict:store(Id, Events, State)
    end.

addEventsToExisting(Id, Events, State) -> 
	case orddict:find(Id, State) of
		{ok, CurrentEvents} ->
			NewEvents = CurrentEvents ++ Events,
			orddict:store(Id, NewEvents, State);
		error ->
			io:format("Unexpected addEventsToExisting: ~p~n",[Id]),
			throw(commandException)
    end.

getEvents(Id, State) -> 
	case orddict:find(Id, State) of
		{ok, CurrentEvents} ->
			CurrentEvents;
		error ->
			[]
    end.