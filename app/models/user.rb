class User < ApplicationRecord
  has_many :tasks

  before_validation { email.downcase! }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true # format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, length: { minimum: 6 }

  has_secure_password

end
