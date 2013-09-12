-module(cqrs).
-include("commands.hrl").
-include("events.hrl").
-compile(export_all).

start() ->
	eventBus:start_link(),
	eventBus:registerHandler(journalItemCreatedEvent, journalItemQueryModelBuilder),
	eventBus:registerHandler(journalItemDeletedEvent, journalItemQueryModelBuilder),
	commandBus:start_link(),
	commandBus:registerHandler(createJournalItemCommand, journalItemCommandHandler),
	commandBus:registerHandler(deleteJournalItemCommand, journalItemCommandHandler),
	ok.

dispatch(Command, CommandData) ->
	commandBus:dispatch(Command, CommandData).