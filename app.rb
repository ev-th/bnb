require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/listing_repository'
require_relative 'lib/database_connection'

DatabaseConnection.connect('bnb_database_test')

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end
  
  get '/listings/:id' do
    repo = ListingRepository.new

    @listing = repo.find(params[:id])

    return erb(:listing)
  end
end

# Returns an html view with a calendar available dates for a listing. 
# User can choose on a date and click ‘request to book’ button 
# to create a booking request on the database table.
# dates for confirmed bookings shouldn’t be selectable.