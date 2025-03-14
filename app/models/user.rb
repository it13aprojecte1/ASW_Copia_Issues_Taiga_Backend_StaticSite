class User < ApplicationRecord
  validates :username, length: { minimum: 1 }
  validates :password, length: { minimum: 1 }

end
