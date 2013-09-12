-module(querystore).

-export([start_link/0, store/3, delete/2, getItems/1, getItem/2]).

start_link() -> 
	querystore_svr:start_link().

store(Table, Id, Data) ->
	querystore_svr:store(Table, Id, Data).

delete(Table, Id) ->
	querystore_svr:delete(Table, Id).

getItems(Table) ->
	querystore_svr:getItems(Table).

getItem(Table, Id) ->
	querystore_svr:getItem(Table, Id).
