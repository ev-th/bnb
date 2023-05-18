require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

describe Application do
  def reset_tables
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'bnb_database_test' })
    connection.exec(seed_sql)
  end
  
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

  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/signup">')
      expect(response.body).to include('<input type="email" name="email" placeholder="email">')
      expect(response.body).to include('<input type="password" name="password" placeholder="password">')
      expect(response.body).to include('<input type="submit">')

      expect(response.body).to include('<form method="POST" action="/login">')
      expect(response.body).to include('<input type="email" name="email" placeholder="email">')
      expect(response.body).to include('<input type="password" name="password" placeholder="password">')
      expect(response.body).to include('<input type="submit">')
    end

    it 'should not return a navbar' do
      response = get('/')
      expect(response.body).not_to include '<nav'
    end
  end

  context 'POST /signup' do
    it 'should add the new user to the database' do

      login_for_test
      
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
      expect(response.body).to include('<a href="/"> back to sign up </a>')
    end

    it 'reroutes to error page if password is empty' do

      response = post(
        '/signup',
        email: 'evan@example.com',
        password: ''
      )

      expect(response.status).to eq 400
      expect(response.body).to include('Sign up fail')
      expect(response.body).to include('<a href="/"> back to sign up </a>')
    end
  end

  context 'POST /login' do
    it 'logs in an exisiting user when correct details are submitted' do

      response = post(
        '/login',
        email: 'julian@example.com',
        password: 'test'
      )

      response = get('/listings')
      expect(response.status).to eq 200
      expect(response.body).to include 'These are the listings'
    end
  end

  context 'GET /listings' do
    it 'should return the list of the listings' do
      response = get('/listings')
        
      expect(response.status).to eq 302

      login_for_test

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
      login_for_test
     
      response = get('/listings')

      expect(response.body).to include '<nav'
    end
  end

  context 'GET /listings/new' do
    it 'should return a form to add a new listing' do
      response = get('/listings/new')
        
      expect(response.status).to eq 302

      login_for_test
    
      response = get('/listings/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('Add a new listing')
      expect(response.body).to include('<form method="POST" action="/listings/new">')
    end
  end

  context 'POST /listings/new' do
    it 'should add a new listing' do
      login_for_test
     
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
      expect(listings.last.user_id).to eq('1')

      expect(response.status).to eq 200
      expect(response.body).to include('Listing added successfully')

      response = get('/listings')
      expect(response.body).to include('listing_3')

    end

    it 'should return a failing message' do
      login_for_test
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

  context 'POST /requests/confirm' do
    it 'post a TRUE value to the database' do
      response = post('/requests/confirm/1')
      expect(response.status).to eq 200

      repo = BookingRepository.new 
      booking = repo.find(1)
      expect(booking.confirmed).to eq true
    end
  end

  context 'GET /requests' do
    it 'returns 200 OK' do
      response = get('/requests')
      expect(response.status).to eq 302
      login_for_test
      
      response = get('/requests')
      expect(response.status).to eq 200
    end

    it 'displays confirm button' do
      post(
        '/login',
        email: 'julian@example.com',
        password: 'test'
      )
      response = get('/requests')
      expect(response.status).to eq 200
      expect(response.body).to include("confirm")
    end

    it 'should include the booker\'s email adrress' do
      post(
        '/login',
        email: 'julian@example.com',
        password: 'test'
      )
      response = get('/requests')
      expect(response.status).to eq 200
      expect(response.body).to include 'andrea@example.com'
    end
    
    it 'displays the listing name' do
      post(
        '/login',
        email: 'julian@example.com',
        password: 'test'
      )
      response = get('/requests')
      expect(response.body).to include 'listing_1'
    end
    
    it 'displays a different listing name when logged in to another account' do
      post(
        '/login',
        email: 'andrea@example.com',
        password: 'test'
      )
      response = get('/requests')
      expect(response.body).to include 'listing_2'
    end
    
    it 'displays the date of the listing' do
      post(
        '/login',
        email: 'julian@example.com',
        password: 'test'
      )
      response = get('/requests')
      expect(response.body).to include '2023-04-09'
    end
  end

  context 'POST /logout' do
    it 'should log out the user' do
      login_for_test
      response = post('/logout')

      expect(response.status).to eq 302

    end
  end
end