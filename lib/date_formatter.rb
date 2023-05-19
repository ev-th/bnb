class DateFormatter
  def self.format(date)
    time_obj = Time.new(*date.split('-'))
    time_obj.strftime('%-d %B %Y')
  end
end