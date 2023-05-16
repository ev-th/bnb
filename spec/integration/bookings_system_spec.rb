require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.

  context 'get/listings/:id' do
    it "gets listing 1 and has a form to request booking" do
      response = get('/listings/1')
      expect(response.status).to eq(200)
      expect(response.body).to include ('listing_1')
      expect(response.body).to include ('<form method="POST" action="/listings/:id/booking">')
      expect(response.body).to include ('<input type="date" name="date" min="2023-04-08" max="2023-05-09">')
      expect(response.body).to include ('<input type="submit", value="request to book">')
    end

    it "gets listing 2 and has a form to request booking" do
      response = get('/listings/2')
      expect(response.status).to eq(200)
      expect(response.body).to include ('listing_2')
      expect(response.body).to include ('<form method="POST" action="/listings/:id/booking">')
      expect(response.body).to include ('<input type="date" name="date" min="2024-05-03" max="2024-06-23">')
      expect(response.body).to include ('<input type="submit", value="request to book">')
    end
  end
  context 'POST /listings/:id/booking' do
    it 'posts a selected date to bookings' do
    response = post('/listings/1/booking', date: '2023-04-10', confirmed: false, listing_id: '1', user_id: '1')
    expect(response.status).to eq(200)
    expect(response.body).to eq('')

    repo = BookingRepository.new
    new_booking = repo.find(4)

    expect(new_booking.id).to eq 4
    expect(new_booking.date).to eq '2023-04-10'
    expect(new_booking.confirmed).to eq false
    expect(new_booking.listing_id).to eq 1
    expect(new_booking.user_id).to eq 1
    end
  end
end