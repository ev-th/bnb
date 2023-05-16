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

  get '/listings' do
    repo = ListingRepository.new
    @listings = repo.all

    return erb(:listings)
  end

  get '/listings/new' do
    return erb(:new_listing)
  end

  post '/listings/new' do
    repo = ListingRepository.new
    new_listing = Listing.new
    
    new_listing.name = params[:name]
    repo.create(new_listing)
  end
end