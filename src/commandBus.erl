-module(commandBus).

-export([start_link/0, registerHandler/2, dispatch/2]).

start_link() -> 
	commandBus_svr:start_link().

registerHandler(Command, CommandHandler) ->
	commandBus_svr:registerHandler(Command, CommandHandler).

dispatch(Command, CommandData) ->
	commandBus_svr:dispatch(Command, CommandData).