-module(journalItemAggregate).

-include("commands.hrl").
-include("events.hrl").

-behaviour(aggregate).

-record(state, {blocked}).

-export([init/0, do/3, apply/3]).

init() -> #state{}.

do(createJournalItemCommand, C=#createJournalItemCommand{}, _State=#state{}) ->
	E = #journalItemCreatedEvent{
			journalItem=C#createJournalItemCommand.journalItem,
			name=C#createJournalItemCommand.name,
			description=C#createJournalItemCommand.description,
			salesrelation=C#createJournalItemCommand.salesrelation,
			blocked=C#createJournalItemCommand.blocked,
			deadline=C#createJournalItemCommand.deadline},

	% check:all items should have a name
	case C#createJournalItemCommand.name == [] of
		true -> throw(commandException); %can / should we add extra info to the throw?
	    false -> [{journalItemCreatedEvent, E}]
	end;
do(deleteJournalItemCommand, C=#deleteJournalItemCommand{}, State=#state{}) ->
	E = #journalItemDeletedEvent{
			journalItem=C#deleteJournalItemCommand.journalItem},

	% check: blocked items cannot be deleted
	case State#state.blocked of
		true -> throw(commandException); %can / should we add extra info to the throw?
	    false -> [{journalItemDeletedEvent, E}]
	end.

apply(journalItemCreatedEvent, #journalItemCreatedEvent{blocked=B}, State=#state{}) ->
	State#state{blocked=B};
apply(_, _, State=#state{}) ->
	State.
