require 'user_repository'

def reset_users_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'bnb_database_test' })
  connection.exec(seed_sql)
end

RSpec.describe UserRepository do
  before(:each) do 
    reset_users_table
  end
  
  describe '#all' do
    it 'returns a list of all users' do
      repo = UserRepository.new
      expect(repo.all.length).to eq 2
    end
  end

  describe "#create" do
    it 'adds a user to the database' do
      repo = UserRepository.new
      user = User.new
      user.email = 'test_1@example.com'
      user.password = 'password123'
      repo.create(user)

      expect(repo.all).to include(
        have_attributes(
          id: 3,
          email: 'test_1@example.com',
          password: 'password123'
        )
      )
    end
  end
end