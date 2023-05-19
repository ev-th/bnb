require 'booking'

RSpec.describe Booking do
  it 'formats the date into readable string' do
    booking = Booking.new
    booking.date = '2005-05-20'
    fake_formatter = double :fake_formatter
    allow(fake_formatter).to receive(:format).with('2005-05-20').and_return('20 May 2005')
    result = booking.formatted_date(formatter = fake_formatter)
    expect(result).to eq '20 May 2005'
  end
end