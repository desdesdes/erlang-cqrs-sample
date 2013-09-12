-module(cqrs).
-include("commands.hrl").
-include("events.hrl").
-export([start/0, dispatch/2, test/0]).

start() ->
	eventstore:start_link(),
	querystore:start_link(),

	eventBus:start_link(),
	eventBus:registerHandler(journalItemCreatedEvent, journalItemQueryModelBuilder),
	eventBus:registerHandler(journalItemDeletedEvent, journalItemQueryModelBuilder),
	
	commandBus:start_link(),
	commandBus:registerHandler(createJournalItemCommand, journalItemCommandHandler),
	commandBus:registerHandler(deleteJournalItemCommand, journalItemCommandHandler).

dispatch(Command, CommandData) ->
	commandBus:dispatch(Command, CommandData).

addTestData() ->
	dispatch(createJournalItemCommand, #createJournalItemCommand{journalItem="a", name="a", blocked=false}),
	dispatch(deleteJournalItemCommand, #deleteJournalItemCommand{journalItem="a"}),
	dispatch(createJournalItemCommand, #createJournalItemCommand{journalItem="b", name="b", blocked=false}),
	dispatch(createJournalItemCommand, #createJournalItemCommand{journalItem="c", name="c", blocked=true}).
