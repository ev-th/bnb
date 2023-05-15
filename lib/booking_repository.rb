require_relative 'booking'

class BookingRepository
  
  def find(booking_id)
    sql = 'SELECT id, date, confirmed, listing_id, user_id FROM bookings WHERE id = $1;'
    sql_params = [booking_id]
    record_set = DatabaseConnection.exec_params(sql, sql_params)

    record = record_set.first

    booking = Booking.new

    set_attributes(booking, record)

    return booking
   end

  # returns an array of booking objects that have the same listing id
  def find_by_listing(listing_id)
   sql = "SELECT id, date, confirmed, listing_id, user_id FROM bookings WHERE listing_id = $1;"
   sql_params = [listing_id]
   record_set = DatabaseConnection.exec_params(sql, sql_params)

   bookings = []

   record_set.each do |record|
    booking = Booking.new
    set_attributes(booking, record)
    bookings << booking
   end

   return bookings
  end

  def create(booking)
    sql = 'INSERT INTO bookings (date, confirmed, listing_id, user_id) VALUES($1, $2, $3, $4);'
    sql_params = [booking.date, booking.confirmed, booking.listing_id, booking.user_id]
    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def confirm_booking(booking) 
    sql = 'UPDATE bookings SET confirmed = $1 WHERE id = $2;'
    booking.confirmed = true
    sql_params = [booking.confirmed, booking.id]
    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end
  private

  # The confirmed column is a boolean data type in PSQL, but when the PG gem fetches it from ruby
  # it comes back as either 't' or 'f'. This method converts those values into true or false.

  def to_boolean(string)
   string == "t" ? true : false 
  end

 # this method sets the attributes of a given booking object to the attributes of a given record 
  def set_attributes(booking, record)
    booking.id = record['id'].to_i
    booking.date = record['date']
    booking.confirmed = to_boolean(record['confirmed'])
    booking.listing_id = record['listing_id'].to_i
    booking.user_id = record['user_id'].to_i  
  end

end