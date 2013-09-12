-module(querystore_svr).

-behaviour(gen_server).

-export([start_link/0, store/3, delete/2, getItems/1, getItem/2]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%%% Client functions
start_link() -> 
	{_,Pid} = gen_server:start_link(?MODULE, [], []),
	register(?MODULE, Pid).

store(Table, Id, Data) ->
	gen_server:call(?MODULE, {store, Table, Id, Data}).

delete(Table, Id) ->
	gen_server:call(?MODULE, {delete, Table, Id}).

getItems(Table) ->
	gen_server:call(?MODULE, {getItems, Table}).

getItem(Table, Id) ->
	gen_server:call(?MODULE, {getItem, Table, Id}).

%%% Server functions
init([]) -> 	
	{ok, orddict:new()}. % init state

handle_call({store, Table, Id, Data}, _From, State) ->
	NewState = storeItem(Table, Id, Data, State),
	{reply, ok, NewState};
handle_call({delete, Table, Id}, _From, State) ->
	NewState = deleteItem(Table, Id, State),
	{reply, ok, NewState};
handle_call({getItem, Table, Id}, _From, State) ->
    {reply, retrieveItem(Table, Id, State), State};
handle_call({getItems, Table}, _From, State) ->
    {reply, retrieveItems(Table, State), State};
handle_call(Msg, _From, State) ->
	io:format("Unexpected message: ~p~n",[Msg]),
	{stop, normal, State}.
 
handle_cast(Msg, State) ->
	io:format("Unexpected message: ~p~n",[Msg]),
	{stop, normal, State}.

handle_info(Msg, State) ->
	io:format("Unexpected message: ~p~n",[Msg]),
	{stop, normal, State}.

terminate(_Msg, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	%% No change planned. The function is there for the behaviour,
	%% but will not be used. Only a version on the next
	{ok, State}.

storeItem(TableId, Id, Data, State) -> 
	case orddict:find(TableId, State) of
		{ok, Table} ->
			% add or update row 
			NewTable = orddict:store(Id, Data, Table),
			orddict:store(TableId, NewTable, State);
		error ->
			% add table, it did not exist
			NewTable = orddict:store(Id, Data, orddict:new()),
			orddict:store(TableId, NewTable, State)
    end.

deleteItem(TableId, Id, State) -> 
	case orddict:find(TableId, State) of
		{ok, Table} ->
			NewTable = orddict:erase(Id, Table),
			orddict:store(TableId, NewTable, State);
		error ->
			State
    end.

retrieveItem(TableId, Id, State) ->
	case orddict:find(TableId, State) of
		{ok, Table} ->
			case orddict:find(Id, Table) of
				{ok, Data} -> 
					Data;
				error ->
					undefined
			end;
		error ->
			undefined
    end.

retrieveItems(TableId, State) ->
	case orddict:find(TableId, State) of
		{ok, Table} ->
			orddict:fold(fun(_Key,Value, Acc) -> Acc ++ [Value] end, [], Table);
		error ->
			[]
    end.