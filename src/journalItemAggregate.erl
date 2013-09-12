-module(journalItemAggregate).

-include("commands.hrl").
-include("events.hrl").

-behaviour(aggregate).

-record(state, {blocked}).

-export([init/0, do/3, apply/3]).

init() -> #state{}.

do(createJournalItemCommand, C=#createJournalItemCommand{}, _State=#state{}) ->
	io:format("do: ~p~n",[C]),
	E = #journalItemCreatedEvent{
			journalItem=C#createJournalItemCommand.journalItem,
			name=C#createJournalItemCommand.name,
			description=C#createJournalItemCommand.description,
			salesrelation=C#createJournalItemCommand.salesrelation,
			blocked=C#createJournalItemCommand.blocked,
			deadline=C#createJournalItemCommand.deadline},

	case C#createJournalItemCommand.name == [] of
		true -> throw(commandException); %can i add extra info to the throw?
	    false -> [{journalItemCreatedEvent, E}]
	end;
do(deleteJournalItemCommand, C=#deleteJournalItemCommand{}, State=#state{}) ->
	io:format("do: ~p~n",[C]),
	E = #journalItemDeletedEvent{
			journalItem=C#deleteJournalItemCommand.journalItem},

	case State#state.blocked of
		true -> throw(commandException); %can i add extra info to the throw?
	    false -> [{journalItemDeletedEvent, E}]
	end.

apply(journalItemCreatedEvent, J=#journalItemCreatedEvent{blocked=B}, State=#state{}) ->
	io:format("apply: ~p~n",[J]),
	NewState = State#state{blocked=B},
	io:format("apply state: ~p~n",[NewState]),
	NewState;
apply(_, _, State=#state{}) ->
	io:format("apply state: ~p~n",[State]),
	State.
