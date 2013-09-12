-module(journalItemCommandHandler).

-include("commands.hrl").

-behaviour(commandHandler).

-export([handle/2]).

handle(createJournalItemCommand, C=#createJournalItemCommand{}) -> 
	commandHandler:add(journalItemAggregate, 
					   C#createJournalItemCommand.journalItem, 
					   createJournalItemCommand,
					   C);
handle(deleteJournalItemCommand, C=#deleteJournalItemCommand{}) -> 
	commandHandler:update(journalItemAggregate, 
						  C#deleteJournalItemCommand.journalItem, 
						  deleteJournalItemCommand,
						  C).