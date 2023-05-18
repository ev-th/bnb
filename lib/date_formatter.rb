class DateFormatter
  def self.format(date)

    year, month, day = date.split('-')
    time_obj = Time.new(year, month, day)
    time_obj.strftime('%-d %B %Y')
  end
end