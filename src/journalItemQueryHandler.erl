-module(journalItemQueryHandler).

-include("queryModelObjects.hrl").

-export([getJournalItem/1, getJournalItems/0]).

getJournalItem(Id) -> 
	querystore:getItem(journalItemQmo, Id).

getJournalItems() -> 
	querystore:getItems(journalItemQmo).