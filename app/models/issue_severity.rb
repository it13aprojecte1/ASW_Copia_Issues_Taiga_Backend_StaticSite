class IssueSeverity < ApplicationRecord
   has_many :issues
  validates :name, presence: true, uniqueness: true
  validates :color, presence: true
  validates :position, numericality: { only_integer: true }

  default_scope { order(position: :asc) }
end
