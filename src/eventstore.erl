-module(eventstore).

-export([start_link/0, storeAddToNew/2, storeAddToExisting/2, retrieve/1]).

start_link() -> 
	eventstore_svr:start_link().

storeAddToNew(Id, Events) ->
	eventstore_svr:storeAddToNew(Id, Events).

storeAddToExisting(Id, Events) ->
	eventstore_svr:storeAddToExisting(Id, Events).

retrieve(Id) ->
	eventstore_svr:retrieve(Id).