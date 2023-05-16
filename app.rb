require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/signup' do
    user = User.new
    user.email = params[:email]
    user.password = params[:password]
    
    repo = UserRepository.new
    repo.create(user)
    return erb(:signup_success)
  end
end