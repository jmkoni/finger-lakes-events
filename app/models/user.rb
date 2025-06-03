class User < ApplicationRecord
  passwordless_with :email
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
