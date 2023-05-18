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

    it 'returns the details for user at id 1' do
      repo = UserRepository.new
      users = repo.all

      expect(users.first.id).to eq(1)
      expect(users.first.email).to eq('julian@example.com')
      # expect(users.first.password).to eq('asdasd')
      expect(BCrypt::Password.new(users.first.password)).to eq('test')
    end
  end

  describe "#create" do
    it 'adds a user to the database' do
      repo = UserRepository.new
      user = User.new
      user.email = 'test_1@example.com'
      user.password = 'password123'
      repo.create(user)

      expect(repo.all.length).to eq 3
    end
  end

  describe "#find" do
    it 'finds the user information with id 1' do
      repo = UserRepository.new
      user = repo.find(1)

      expect(user.id).to eq(1)
      expect(user.email).to eq('julian@example.com')
      expect(BCrypt::Password.new(user.password)).to eq('test')
    end

    it 'finds the user information with id 2' do
      repo = UserRepository.new
      user = repo.find(2)

      expect(user.id).to eq(2)
      expect(user.email).to eq('andrea@example.com')
      expect(BCrypt::Password.new(user.password)).to eq('test')
    end
  end
end
