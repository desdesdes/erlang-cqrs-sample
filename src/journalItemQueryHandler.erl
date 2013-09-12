-module(journalItemQueryHandler).

-include("queryModelObjects.hrl").

-export([getItems/4]).

getItems(_Skip, _Take, _SortColumn, _SortType) -> 
	% read from the database.
	Item1 =#dossieritemDetailsQmo{journalItem=1,
				                   name="a",
				                   description="a",
				                   salesrelation=3,
				                   blocked=false,
				                   deadline={{2013,9,11},{16,53,0}}},
    Item2 =#dossieritemDetailsQmo{journalItem=2,
				                   name="b",
				                   description="b",
				                   salesrelation=3,
				                   blocked=false,
				                   deadline={{2013,9,11},{16,53,6}}},
	[Item1, Item2].