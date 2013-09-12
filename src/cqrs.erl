-module(cqrs).
-include("commands.hrl").
-include("events.hrl").
-compile(export_all).

start() ->
	commandBus:start_link(),
	commandBus:registerHandler(createJournalItemCommand, journalItemCommandHandler),
	commandBus:registerHandler(deleteJournalItemCommand, journalItemCommandHandler),
	ok.

dispatch(Command, CommandData) ->
	commandBus:dispatch(Command, CommandData).