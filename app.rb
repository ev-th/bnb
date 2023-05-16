require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/listing_repository'
require_relative 'lib/user_repository'
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

  get '/listings/:id' do
    repo = ListingRepository.new

    @listing = repo.find(params[:id])

    return erb(:listing)
  end

  post '/listings/new' do
       
    repo = ListingRepository.new
    new_listing = Listing.new
    
    new_listing.name = params[:name]
    new_listing.price = params[:price]
    new_listing.description = params[:description]
    new_listing.start_date = params[:start_date]
    new_listing.end_date = params[:end_date]
    new_listing.user_id = params[:user_id]
    
    if dates_checker(new_listing)
      status 400
      return "The end date must be after the start date. <button onclick='history.back();'>Try again.</button>"
    else

      repo.create(new_listing)
    end
  end

  private

  def dates_checker(new_listing)
    start_date_parts = new_listing.start_date.split('-')
    start_date_to_check = Time.new(*start_date_parts)
    
    end_date_parts = new_listing.end_date.split('-')
    end_date_to_check = Time.new(*end_date_parts)

    if start_date_to_check > end_date_to_check
      return true
    end
  end

  post '/signup' do
    user = User.new
    user.email = params[:email]
    user.password = params[:password]
    
    repo = UserRepository.new
    repo.create(user)
    if user.email.empty? || user.password.empty?
      status 400
      return erb(:signup_fail)
    else
      return erb(:listings)
    end
  end
end