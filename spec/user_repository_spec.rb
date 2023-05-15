require 'user_repository'

RSpec.describe UserRepository do
  describe '#all' do
    it 'returns a list of all users' do
      repo = UserRepository.new
      expect(repo.all.length).to eq 2
    end
  end

  describe "#create" do
    xit 'adds a user to the database' do
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