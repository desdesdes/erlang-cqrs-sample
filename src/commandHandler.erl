-module(commandHandler).

-export([behaviour_info/1, add/4, single/4]).
 
%% init/1, some_fun/0 and other/3 are now expected callbacks
behaviour_info(callbacks) -> [{handle, 2}];
behaviour_info(_) -> undefined.


add(Aggregate, _Id, Command, CommandData) ->
	StartState = Aggregate:init(),
	Events = Aggregate:do(Command, CommandData, StartState),

	% apply the events to the aggregate
	_NewState = applyEvent(Aggregate, Events, StartState),
	% store the new event
	% push the event to the rest of the system
	% new state could be stored to improve load performance
	ok.

single(Aggregate, _Id, Command, CommandData) -> 
	StartState = Aggregate:init(),

	% load all the events for the aggregate id and apply all of them
	% LastGoodState = applyEvent(Aggregate, Events, undefined),

	Events = Aggregate:do(Command, CommandData, StartState),

	% apply the events to the aggregate
	_NewState = applyEvent(Aggregate, Events, undefined),
	% store the new event
	% push the event to the rest of the system
	% new state could be stored to improve load performance
	ok.

applyEvent(_Aggregate, [], State) ->
	State;
applyEvent(Aggregate, [H|T], State) ->
	{NewEvent, NewEventData} = H,
	Aggregate:apply(NewEvent, NewEventData, State),
	applyEvent(Aggregate, T, State).
