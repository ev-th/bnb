require_relative './date_formatter'

class Booking
  attr_accessor :id, :date, :confirmed, :listing_id, :user_id 

  def formatted_date(formatter = DateFormatter)
    formatter.format(@date)
  end
end