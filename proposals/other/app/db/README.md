# DB

## CoreDataAdapter

Rationale: CD is widely used in iOS projects and may be useful for simpler
integration with UI.

## SqlLiteAdapter

This would be responsible for handling CoreData+Sqlite backend.

## RemoteAdapter

This would be responsible for handling remote data sources (initially just JSON).

* A RemoteAdapter would be migration-less, APIs would need to be backwards compatible or be versioned, see endpoint in `models/event.rb`