-module(journalItemQueryModelBuilder).

-include("queryModelObjects.hrl").
-include("events.hrl").

-behaviour(eventHandler).

-export([handle/2]).

handle(journalItemCreatedEvent, E=#journalItemCreatedEvent{}) -> 
	io:format("journalItemQueryModelBuilder: ~p~n",[E]),
	Data =#journalItemCreatedEvent{journalItem = E#journalItemCreatedEvent.journalItem,
				                   name = E#journalItemCreatedEvent.name,
				                   description = E#journalItemCreatedEvent.description,
				                   salesrelation = E#journalItemCreatedEvent.salesrelation,
				                   blocked = E#journalItemCreatedEvent.blocked,
				                   deadline = E#journalItemCreatedEvent.deadline},

	% write to db
	querystore:store(journalItemQmo, E#journalItemCreatedEvent.journalItem, Data);
handle(journalItemDeletedEvent, E=#journalItemDeletedEvent{}) -> 
	io:format("journalItemQueryModelBuilder: ~p~n",[E]),
	% remove from DB
	querystore:delete(journalItemQmo, E#journalItemDeletedEvent.journalItem).
