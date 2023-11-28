# Temporarily connect to a different database

```ruby
def with_other_db
  other_database_url = 'postgresql://username:pass@host/db_name'
  original_connection = ActiveRecord::Base.remove_connection
  ActiveRecord::Base.establish_connection other_database_url
  yield
ensure
  ActiveRecord::Base.establish_connection original_connection
end
```
