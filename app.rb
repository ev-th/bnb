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

    @listing_id = repo.find(params[:id])

    return erb(:listings_id)
  end
end

    # repo = AlbumRepository.new
    # artist_repo = ArtistRepository.new

    # @album = repo.find(params[:id])
    # @artist = artist_repo.find(@album.artist_id)

    # return erb(:album)

# Returns an html view with a calendar available dates for a listing. 
# User can choose on a date and click ‘request to book’ button 
# to create a booking request on the database table.
# dates for confirmed bookings shouldn’t be selectable.