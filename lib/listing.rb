require_relative './date_formatter'

class Listing
  attr_accessor :id, :name, :price, :description, :start_date, :end_date, :user_id

  def formatted_start_date(formatter = DateFormatter)
    formatter.format(@start_date)
  end

  def formatted_end_date(formatter = DateFormatter)
    formatter.format(@end_date)
  end
end