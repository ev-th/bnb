require_relative 'user'
require 'bcrypt'

class UserRepository
  def all
    sql = 'SELECT id, email, password FROM users;'
    result_set = DatabaseConnection.exec_params(sql, [])
    users = []
    result_set.each do |record|
      users << record_to_user(record)
    end
    return users
  end
  
  def create(user)
    password = BCrypt::Password.create(user.password)

    sql = 'INSERT INTO users(email, password) VALUES ($1, $2);'
    params = [user.email, password]
    result_set = DatabaseConnection.exec_params(sql, params)
  end

  def find(id)
    sql = 'SELECT id, email , password FROM users WHERE id = $1;'
    params = [id]
    
    result_set = DatabaseConnection.exec_params(sql, params)
    return record_to_user(result_set[0])
  end 

  def find_by_email(email)
    sql = 'SELECT id, email , password FROM users WHERE email = $1;'
    params = [email]
    
    result_set = DatabaseConnection.exec_params(sql, params)
    return record_to_user(result_set[0])
  end 

  def password_correct?(encrypted_password, submitted_password)

    if BCrypt::Password.new(encrypted_password) == submitted_password
      return true
    else false
    end
  end

  private 

  def record_to_user(record)
    user = User.new
    user.id = record['id'].to_i
    user.email = record['email']
    user.password = record['password']
   return user
  end
end