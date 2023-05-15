# LISTINGS Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table (done)


```

## 2. Create Test SQL seeds (done)


```bash

```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: listings

# Model class
# (in lib/listing.rb)
class Listing
end

# Repository class
# (in lib/listing_repository.rb)
class ListingRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: listings

# Model class
# (in lib/listing.rb)

class Listing

  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :price, :description, :start_date, :end_date, :user_id
end


```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: listings

# Repository class
# (in lib/listing_repository.rb)

class ListingRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, price, description, start_date, end_date, user_id FROM listings;

    # Returns an array of Listing objects.
  end

  def create(listing)
    # Executes the SQL query:
    # INSERT INTO listings (name, price, description, start_date, end_date, user_id) VALUES ($1, $2, $3, $4, $5, $6);

    # return nothing
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  # def find(id)
  #   # Executes the SQL query:
  #   # SELECT id, name, cohort_name FROM students WHERE id = $1;

  #   # Returns a single Student object.
  # end

  # Add more methods below for each operation you'd like to implement.
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all listings

repo = ListingRepository.new

listings = repo.all

listings.length # =>  2

listings[0].id # =>  '1'
listings[0].name # =>  'listing_1'
listings[0].description # =>  'sunny place'

listings[1].start_date # =>  '2024-05-03'
listings[1].end_date # =>  '2024-06-23'
listings[1].user_id # =>  '2'

# 2
# create a new listing

repo = ListingRepository.new
new_listing = Listing.new
new_listing.name = 'listing_3'
new_listing.price = '1750'
new_listing.description = 'cloudy place'
new_listing.start_date = '2024-05-15'
new_listing.end_date = '2024-07-23'
new_listing.user_id = '1'
repo.create(new_listing)

listings = repo.all

listings.length # =>  3
listings.last.name # =>  'listing_3'
listings.last.description # =>  'cloudy place'
listings.last.price # =>  '1750'




# # 2
# # Get a single student

# repo = StudentRepository.new

# student = repo.find(1)

# student.id # =>  1
# student.name # =>  'David'
# student.cohort_name # =>  'April 2022'

# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/listing_repository_spec.rb

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'bnb_database_test' })
  connection.exec(seed_sql)
end

describe ListingRepository do
  before(:each) do 
    reset_tables
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->