require 'listing'

class ListingRepository

  def all
    sql = 'SELECT id, name, price, description, start_date, end_date, user_id FROM listings;'
    result_set = DatabaseConnection.exec_params(sql, [])

    listings = []

    result_set.each do |record|
      listing = Listing.new
      listing.id = record['id']
      listing.name = record['name']
      listing.price = record['price']
      listing.description = record['description']
      listing.start_date = record['start_date']
      listing.end_date = record['end_date']
      listing.user_id = record['user_id']

      listings << listing
    end
    return listings

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