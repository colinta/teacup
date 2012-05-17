# DB

I think we'd need two adapters:

## SqlLiteAdapter

This would be responsible for handling CoreData+Sqlite backend.

## RemoteAdapter

This would be responsible for handling remote data sources (initially just JSON).

* A RemoteAdapter would be migration-less, APIs would need to be backwards compatible or be versioned, see endpoint in `models/event.rb`