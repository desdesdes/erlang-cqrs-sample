-module(journalItemCommandHandler).

-include("commands.hrl").

-behaviour(commandHandler).

-export([handle/2]).

handle(createJournalItemCommand, C=#createJournalItemCommand{}) -> 
	commandHandler:add(journalItemAggregate, C#createJournalItemCommand.journalItem, C);
handle(deleteJournalItemCommand, C=#deleteJournalItemCommand{}) -> 
	commandHandler:single(journalItemAggregate, C#deleteJournalItemCommand.journalItem, C).