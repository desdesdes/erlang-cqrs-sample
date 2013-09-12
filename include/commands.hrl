%% this is a .hrl (header) file.
-record(createJournalItemCommand, {journalItem,
				                   name,
				                   description,
				                   salesrelation,
				                   blocked,
				                   deadline}).

-record(deleteJournalItemCommand, {journalItem}).