require 'date_formatter'

RSpec.describe DateFormatter do
  it 'formats a YYYY-MM-DD string date' do
    date = '2023-01-01'
    formatted_date = DateFormatter.format(date)
    expect(formatted_date).to eq '1 January 2023'
  end
  
  it 'formats another YYYY-MM-DD string date' do
    date = '1999-12-31'
    formatted_date = DateFormatter.format(date)
    expect(formatted_date).to eq '31 December 1999'
  end
end