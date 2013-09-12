-module(eventstore).

-export([start_link/0, storeNew/2, storeAdd/2, retrieve/1]).

start_link() -> 
	eventstore_svr:start_link().

storeNew(Id, Events) ->
	eventstore_svr:storeNew(Id, Events).

storeAdd(Id, Events) ->
	eventstore_svr:storeAdd(Id, Events).

retrieve(Id) ->
	eventstore_svr:retrieve(Id).