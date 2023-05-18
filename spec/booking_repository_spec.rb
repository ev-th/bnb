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

  context 'gets all bookings' do
    it 'returns all the bookings' do
      repo = BookingRepository.new

      bookings = repo.all

      expect(bookings.length).to eq 3
      
      first_booking = bookings.first
      expect(first_booking.date).to eq '2023-04-09'
      expect(first_booking.confirmed).to eq false
      expect(first_booking.listing_id).to eq 1
      expect(first_booking.user_id).to eq 2
    end
  end

  context '#find_by_listing' do
    it "returns all the bookings associated with a given listing's id" do
      repo = BookingRepository.new

      bookings = repo.find_by_listing(1)

      expect(bookings.length).to eq 2
      
      first_booking = bookings.first

      expect(first_booking.date).to eq '2023-04-09'
      expect(first_booking.confirmed).to eq false
      expect(first_booking.listing_id).to eq 1
      expect(first_booking.user_id).to eq 2

      second_booking = bookings.last

      expect(second_booking.date).to eq '2023-04-10'
      expect(second_booking.confirmed).to eq false
      expect(second_booking.listing_id).to eq 1
      expect(second_booking.user_id).to eq 2      
    end
  end
  context '#create(booking)' do
    it 'creates a new booking and adds it to the database' do
    repo = BookingRepository.new

    new_booking = Booking.new
    new_booking.date= '2023-06-16'
    new_booking.confirmed = false
    new_booking.listing_id = 2
    new_booking.user_id = 2

    repo.create(new_booking)

    last_booking = repo.find(4)

    expect(last_booking.date).to eq '2023-06-16'
    expect(last_booking.confirmed).to eq false
    expect(last_booking.listing_id).to eq 2
    expect(last_booking.user_id).to eq 2
    end
    context '#confirm_booking(booking)' do
      it 'turns a false to true to confrim a booking' do
        repo = BookingRepository.new

        booking = repo.find(1)

        repo.confirm_booking(booking)

        expect(booking.confirmed).to eq true
      end
    end
  end
end