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


  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/signup">')
      expect(response.body).to include('<input type="text" name="email">')
      expect(response.body).to include('<input type="text" name="password">')
      expect(response.body).to include('<input type="submit">')
    end
  end

  context 'POST /signup' do
    it 'should add the new user to the database' do
      response = post(
        '/signup',
        email: 'evan@example.com',
        password: 'pass'
      )
      
      repo = UserRepository.new
      expect(repo.all).to include(
        have_attributes(
          email: 'evan@example.com',
          password: 'pass'
        )
      )
    end
    
    it 'returns a success page' do
      response = post(
        '/signup',
        email: 'evan@example.com',
        password: 'pass'
      )

      expect(response.status).to eq 200
      expect(response.body).to include 'Success'
      # add a test to link back to listings page
    end
    
    it 'reroutes to error page if email is empty' do
      response = post(
        '/signup',
        email: '',
        password: 'pass'
      )

      expect(response.status).to eq 400
      expect(response.body).to include('Sign up fail')
      expect(response.body).to include('<a href="/signup"> back to sign up </a>')
    end

    it 'reroutes to error page if password is empty' do
      response = post(
        '/signup',
        email: 'evan@example.com',
        password: ''
      )

      expect(response.status).to eq 400
      expect(response.body).to include('Sign up fail')
      expect(response.body).to include('<a href="/signup"> back to sign up </a>')
    end
  end
end
