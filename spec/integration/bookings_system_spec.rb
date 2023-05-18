require "spec_helper"
require "rack/test"
require 'timecop'
require_relative '../../app'
require 'json'

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'bnb_database_test' })
  connection.exec(seed_sql)
end

describe BookingRepository do
  before(:each) do 
    reset_tables
  end

  def login_for_test
    post(
      '/login',
      email: 'julian@example.com',
      password: 'test'
    )
  end
  
  include Rack::Test::Methods

  let(:app) { Application.new }

  describe 'GET /listings/:id' do
     before(:each) do
      Timecop.freeze(Date.new(2023, 4, 07))
    end
    # tells Time class to return to normal after each test
    after(:each) do
      Timecop.return
    end
    
    it "gets listing details for specific listing and has a form to request booking" do
      response = get('/listings/1')
      expect(response.status).to eq 302

      login_for_test
     
      response = get('listings/1')
      expect(response.status).to eq(200)
      expect(response.body).to include ('listing_1')
      expect(response.body).to include ('<form method="POST" action="/listings/1/booking">')
      expect(response.body).to include ('<input type="date" name="date" min="2023-04-08" max="2023-05-09">')
      expect(response.body).to include ('<input type="submit", value="request to book">')

      response = get('listings/2')
      expect(response.status).to eq(200)
      expect(response.body).to include ('listing_2')
      expect(response.body).to include ('<form method="POST" action="/listings/2/booking">')
      expect(response.body).to include ('<input type="date" name="date" min="2024-05-03" max="2024-06-23">')
      expect(response.body).to include ('<input type="submit", value="request to book">')
    end

    context 'given a listing with an availability date before the current day' do
      it 'sets the starting availability date to the current day if the start date is in the past' do
        listing_repository = ListingRepository.new
        # creates a new listing that is before the frozen day
        listing = Listing.new
        listing.name = 'new listing'
        listing.price = '200'
        listing.description = 'a listing with a start date that is before today_fake'
        listing.start_date = '2023-04-01'
        listing.end_date = '2023-05-30'
        listing.user_id = '1'

        listing_repository.create(listing)
        latest_listing_id = listing_repository.all.last.id
        response = get("/listings/#{latest_listing_id }")

        expect(response.status).to eq(200)
        # checks that the starting day has been set to the current day
        expect(response.body).to include ('min="2023-04-07"')
      end
    end
  end


  describe 'POST /listings/:id/booking' do
    it 'posts a selected date to bookings' do
      login_for_test
      response = post('/listings/1/booking', date: '2023-04-10', confirmed: false, listing_id: '1')
      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      repo = BookingRepository.new
      new_booking = repo.find(4)

      expect(new_booking.id).to eq 4
      expect(new_booking.date).to eq '2023-04-10'
      expect(new_booking.confirmed).to eq false
      expect(new_booking.listing_id).to eq 1
    end

    it 'adds the user id of the current session to the booking request' do
      login_for_test
  
      response = post(
        '/listings/1/booking', 
        date: '2023-04-10', 
        confirmed: false, 
        listing_id: '1'
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      repo = BookingRepository.new

      new_booking = repo.all.last
      expect(new_booking.user_id).to eq 3
    end

    # this test does not test that the flash error works yet. We couldn't figure out how to test it.
    # It does work on localhost though.

    it 'flashes an error message when a selected date already has a confirmed booking and does not make a booking' do
      repo = BookingRepository.new
      login_for_test
     
      response = post(
        '/listings/1/booking', 
        date: '2023-04-10', 
        confirmed: false, 
        listing_id: '1'
      )    

      booking = repo.all.last
      repo.confirm_booking(booking)

      # this trys to book the same date again
      response = post(
        '/listings/1/booking', 
        date: '2023-04-10', 
        confirmed: false, 
        listing_id: '1'
      )    

      expect(response.status).to eq (302)

      expect(repo.all.length).to be 4
    end
  end
end