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
      expect(response.body).to include('<input type="email" name="email">')
      expect(response.body).to include('<input type="password" name="password">')
      expect(response.body).to include('<input type="submit">')

      expect(response.body).to include('<form method="POST" action="/login">')
      expect(response.body).to include('<input type="email" name="email">')
      expect(response.body).to include('<input type="password" name="password">')
      expect(response.body).to include('<input type="submit">')
    end

    it 'should not return a navbar' do
      response = get('/')
      expect(response.body).not_to include '<nav'
    end
  end

  context 'POST /signup' do
    it 'should add the new user to the database' do
      response = post(
        '/signup',
        email: 'evan@example.com',
        password: 'pass'
      )

      response = post(
        '/login',
        email: 'evan@example.com',
        password: 'pass'
      )
      
      response = get('/listings')
      expect(response.status).to eq 200
      expect(response.body).to include 'These are the listings'
      expect(response.body).to include 'You are logged in as: 3'
    end
    
    it 'redirects to listings page on success' do
      response = post(
        '/signup',
        email: 'evan@example.com',
        password: 'pass'
      )

      response = get('/listings')
      expect(response.status).to eq 200
      expect(response.body).to include 'These are the listings'
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

  context 'POST /login' do
    it 'logs in an exisiting user when correct details are submitted' do
      response = post(
        '/signup',
        email: 'evan@example.com',
        password: 'pass'
      )
      response = post(
        '/login',
        email: 'evan@example.com',
        password: 'pass'
      )

      response = get('/listings')
      expect(response.status).to eq 200
      expect(response.body).to include 'These are the listings'
      expect(response.body).to include 'You are logged in as: 3'
    end
  end

  context 'GET /listings' do
    it 'should return the list of the listings' do
      response = get('/listings')

      expect(response.status).to eq(200)

      expect(response.body).to include('listing_1')
      expect(response.body).to include('sunny place')
      expect(response.body).to include('£1000')
      
      expect(response.body).to include('listing_2')
      expect(response.body).to include('city penthouse')
      expect(response.body).to include('£1500')
    end

    it 'returns a page with a navbar' do
      response = get('/listings')

      expect(response.body).to include '<nav>'
    end
  end

  context 'GET /listings/new' do
    it 'should return a form to add a new listing' do
      response = get('/listings/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('Add a new listing')
      expect(response.body).to include('<form method="POST" action="/listings/new">')
    end
  end

  context 'POST /listings/new' do
    it 'should add a new listing' do
      response = post(
        '/signup',
        email: 'evan@example.com',
        password: 'pass'
      )
      response = post(
        '/login',
        email: 'evan@example.com',
        password: 'pass'
      )
      response = post(
        '/listings/new',
        name: 'listing_3',
        price: '250',
        description: 'mud hut',
        start_date: '2023-05-16',
        end_date: '2023-07-16',
      )
          
      repo = ListingRepository.new
      
      listings = repo.all
      expect(listings.length).to eq(7)
      expect(listings.last.name).to eq('listing_3')
      expect(listings.last.price).to eq('250')
      expect(listings.last.description).to eq('mud hut')
      expect(listings.last.start_date).to eq('2023-05-16')
      expect(listings.last.end_date).to eq('2023-07-16')
      expect(listings.last.user_id).to eq('3')

      expect(response.status).to eq 200
      expect(response.body).to include('Listing added successfully')

      response = get('/listings')
      expect(response.body).to include('listing_3')

    end

    it 'should return a failing message' do
      response = post(
        '/listings/new',
        name: 'listing_3',
        price: '250',
        description: 'mud hut',
        start_date: '2023-07-16',
        end_date: '2023-05-16',
        user_id: '2'
      )

      expect(response.status).to eq 400
      expect(response.body).to include('The end date must be after the start date')
    end
  end

end
