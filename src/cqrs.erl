-module(cqrs).
-include("commands.hrl").
-include("events.hrl").
-compile(export_all).

start() ->
	ok.

dispatch(command, commandData) ->
	ok.