class Issue < ApplicationRecord
  belongs_to :user
  validates :subject, length: { minimum: 1 }

end


