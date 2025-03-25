class Status < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :color, presence: true
  validates :position, presence: true, uniqueness: true

  default_scope { order(position: :asc) }
end
