require 'booking_repository'

RSpec.describe BookingRepository do

  def reset_bookings_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'bnb_database_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_bookings_table
  end

  context 'When searching for a booking' do
    it 'finds the 1st booking' do
      repo = BookingRepository.new
      booking = repo.find(1)
      expect(booking.id).to eq 1
      expect(booking.date).to eq '2023-04-09'
      expect(booking.confirmed).to eq false
      expect(booking.listing_id).to eq(1)
      expect(booking.user_id).to eq(2)
    end
  end
end