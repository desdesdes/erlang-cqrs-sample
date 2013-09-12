%% this is a .hrl (header) file.
-record(journalItemCreatedEvent, {journalItem,
				                   name,
				                   description,
				                   salesrelation,
				                   blocked,
				                   deadline}).

-record(journalItemDeletedEvent, {journalItem}).