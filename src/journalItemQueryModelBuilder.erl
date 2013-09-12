-module(journalItemQueryModelBuilder).

-include("queryModelObjects.hrl").
-include("events.hrl").

-behaviour(eventHandler).

-export([handle/2]).

handle(journalItemCreatedEvent, _E=#journalItemCreatedEvent{}) -> 
	% write to db
	ok;
handle(journalItemDeletedEvent, _E=#journalItemDeletedEvent{}) -> 
	% remove from DB
	ok.