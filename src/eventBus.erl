-module(eventBus).

-export([start_link/0, registerHandler/2, publish/2]).

start_link() -> 
	eventBus_svr:start_link().

registerHandler(Event, EventHandler) ->
	eventBus_svr:registerHandler(Event, EventHandler).

publish(Event, EventData) ->
	eventBus_svr:publish(Event, EventData).