-module(queryModelBuilder).

-export([behaviour_info/1]).
 
%% init/1, some_fun/0 and other/3 are now expected callbacks
behaviour_info(callbacks) -> [{handle, 2}];
behaviour_info(_) -> undefined.
