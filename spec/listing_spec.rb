require 'listing'

RSpec.describe Listing do
  it 'formats the start date into readable string' do
    listing = Listing.new
    listing.start_date = '2005-05-20'
    fake_formatter = double :fake_formatter
    allow(fake_formatter).to receive(:format).with('2005-05-20').and_return('20 May 2005')
    result = listing.formatted_start_date(formatter = fake_formatter)
    expect(result).to eq '20 May 2005'
  end

  it 'formats the end date into readable string' do
    listing = Listing.new
    listing.end_date = '2004-04-19'
    fake_formatter = double :fake_formatter
    allow(fake_formatter).to receive(:format).with('2004-04-19').and_return('19 April 2004')
    result = listing.formatted_end_date(formatter = fake_formatter)
    expect(result).to eq '19 April 2004'
  end
end