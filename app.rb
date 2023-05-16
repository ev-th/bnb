require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/listing_repository'
require_relative 'lib/user_repository'
require_relative 'lib/database_connection'

DatabaseConnection.connect('bnb_database_test')

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  get '/listings' do
    repo = ListingRepository.new
    @listings = repo.all
    @current_id = session[:user_id]

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

  post '/signup' do
    listing_repo = ListingRepository.new
    @listings = listing_repo.all
    
    user = User.new
    user.email = params[:email]
    user.password = params[:password]
    
    repo = UserRepository.new
    repo.create(user)
    if user.email.empty? || user.password.empty?
      status 400
      return erb(:signup_fail)
    else
      return erb(:index)
    end
  end

  post '/login' do
    listing_repo = ListingRepository.new
    @listings = listing_repo.all

    email = params[:email]
    password = params[:password]

    repo = UserRepository.new
    user = repo.find_by_email(email)
  
    sign_in_status = repo.password_correct?(user.password, password)

    if sign_in_status == true

      session[:user_id] = user.id
      @current_id = session[:user_id]
      
      return erb(:listings)
    else
      return erb(:signup_fail)
    end
  end
end