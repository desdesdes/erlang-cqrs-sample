-module(commandHandler).

-export([behaviour_info/1, add/4, single/4]).
 
%% init/1, some_fun/0 and other/3 are now expected callbacks
behaviour_info(callbacks) -> [{handle, 2}];
behaviour_info(_) -> undefined.

add(Aggregate, Id, Command, CommandData) ->
	StartState = Aggregate:init(),
	Events = Aggregate:do(Command, CommandData, StartState),

	% apply the events to the aggregate
	_NewState = applyEvent(Aggregate, Events, StartState),
	% new state could be stored to improve load performance

	% store the new events
	eventstore:store(Id, Events),

	% push the event to the rest of the system
	publishEvents(Events).

single(Aggregate, Id, Command, CommandData) -> 
	StartState = Aggregate:init(),

	RetrievedEvents = eventstore:retrieve(Id),

	% load all the events for the aggregate id and apply all of them
	LastGoodState = applyEvent(Aggregate, RetrievedEvents, StartState),

	Events = Aggregate:do(Command, CommandData, LastGoodState),

	% apply the events to the aggregate
	_NewState = applyEvent(Aggregate, Events, LastGoodState),
	% new state could be stored to improve load performance

	% store the new events
	eventstore:store(Id, Events),

	% push the event to the rest of the system
	publishEvents(Events).

applyEvent(_Aggregate, [], State) ->
	State;
applyEvent(Aggregate, [H|T], State) ->
	{NewEvent, NewEventData} = H,
	NewState = Aggregate:apply(NewEvent, NewEventData, State),
	applyEvent(Aggregate, T, NewState).

publishEvents([]) ->
	ok;
publishEvents([H|T]) ->
	{NewEvent, NewEventData} = H,
	eventBus:publish(NewEvent, NewEventData),
	publishEvents(T).
