-module(aggregate).

-export([behaviour_info/1]).
 
%% init/1, some_fun/0 and other/3 are now expected callbacks
behaviour_info(callbacks) -> [{init, 0}, {do, 3}, {apply, 3}];
behaviour_info(_) -> undefined.
 