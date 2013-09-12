-module(journalItemQueryModelBuilder).

-include("queryModelObjects.hrl").
-include("events.hrl").

-behaviour(eventHandler).

-export([handle/2]).

handle(journalItemCreatedEvent, E=#journalItemCreatedEvent{}) -> 
	io:format("journalItemQueryModelBuilder journalItemCreatedEvent: ~p~n",[E]),
	% write to db
	ok;
handle(journalItemDeletedEvent, E=#journalItemDeletedEvent{}) -> 
	io:format("journalItemQueryModelBuilder journalItemDeletedEvent: ~p~n",[E]),
	% remove from DB
	ok.