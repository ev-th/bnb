require 'listing_repository'

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'bnb_database_test' })
  connection.exec(seed_sql)
end

describe ListingRepository do
  before(:each) do 
    reset_tables
  end

  it 'Gets all listings' do
    repo = ListingRepository.new

    listings = repo.all

    expect(listings.length).to eq 2

    expect(listings[0].id).to eq '1'
    expect(listings[0].name).to eq 'listing_1'
    expect(listings[0].description).to eq 'sunny place'

    expect(listings[1].start_date).to eq '2024-05-03'
    expect(listings[1].end_date).to eq '2024-06-23'
    expect(listings[1].user_id).to eq '2'

  end

  xit 'creates a new listing' do
    repo = ListingRepository.new
    new_listing = Listing.new
    new_listing.name = 'listing_3'
    new_listing.price = '1750'
    new_listing.description = 'cloudy place'
    new_listing.start_date = '2024-05-15'
    new_listing.end_date = '2024-07-23'
    new_listing.user_id = '1'
    repo.create(new_listing)
    
    listings = repo.all
    
    expect(listings.length).to eq 3
    expect(listings.last.name).to eq 'listing_3'
    expect(listings.last.description).to eq 'cloudy place'
    expect(listings.last.price).to eq '1750'
  end

  it 'Gets all a users listings by a user_id' do
    repo = ListingRepository.new
    new_listing = Listing.new
    new_listing.name = 'listing_3'
    new_listing.price = '1750'
    new_listing.description = 'cloudy place'
    new_listing.start_date = '2024-05-15'
    new_listing.end_date = '2024-07-23'
    new_listing.user_id = '1'
    repo.create(new_listing)
    expect(repo.all.length).to eq 3

    listing = repo.find_by_user_id(1)

    expect(listing.length).to eq 2
    expect(listing[1].id).to eq '3'
    expect(listing[0].id).to eq '1'
    expect(listing[0].name).to include 'listing_1'
    expect(listing[0].description).to include 'sunny place'
    expect(listing[1].description).to include 'cloudy place'
  end
end