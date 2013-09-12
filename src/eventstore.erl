-module(eventstore).

-export([start_link/0, store/2, retrieve/1]).

start_link() -> 
	eventstore_svr:start_link().

store(Id, Events) ->
	eventstore_svr:store(Id, Events).

retrieve(Id) ->
	eventstore_svr:retrieve(Id).