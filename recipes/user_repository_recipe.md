# User Model and Repository Classes Design Recipe


## 1. Design and create the Table

Table and SQL seeds are completed

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: users

# Model class
# (in lib/user.rb)
class User
end

# Repository class
# (in lib/user_repository.rb)
class UserRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby

class User
  attr_accessor :id, :email, :password
end

```


## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: users

# Repository class
# (in lib/user_repository.rb)

class UserRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, email, password FROM users;

    # Returns an array of user objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, email , password FROM users WHERE id = $1;

    # Returns a single user object.
  end

# Take a user as an argument
  def create(user)
  # Executes the SQL query:
  # INSERT INTO users(email, password) VALUES ($1, $2);

  # returns nil, just adds a user
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all users

repo = UserRepository.new
 
repo.all.length # => 2

# 2
# find a single user

repo = UserRepository.new

user = repo.find(1)

user.id # =>  1
user.email # =>  'julian@example.com'
user.password # =>  'asdasd'

# 3
# it adds a user

repo = UserRepository.new
user = User.new
user.email = 'test_1@example.com'
user.password = 'password123'
repo.create(user)

user.email # => 'test_1@example.com'
user.password # => 'password123'
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/user_repository_spec.rb

def reset_users_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'bnb_database_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_users_table
  end

end
```

## 8. Test-drive and implement the Repository class behaviour


