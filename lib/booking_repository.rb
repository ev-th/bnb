require_relative 'booking'

class BookingRepository
  
  def find(booking_id)
    sql = 'SELECT id, date, confirmed, listing_id, user_id FROM bookings WHERE id = $1;'
    sql_params = [booking_id]
    record_set = DatabaseConnection.exec_params(sql, sql_params)

    record = record_set.first
    booking = Booking.new
    booking.id = record['id'].to_i
    booking.date = record['date']
    booking.confirmed = to_boolean(record['confirmed'])
    booking.listing_id = record['listing_id'].to_i
    booking.user_id = record['user_id'].to_i

    return booking
   end

  private
  def to_boolean(string)
   string == "t" ? true : false 
  end
end