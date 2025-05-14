class IssueType < ApplicationRecord
   validates :name, presence: true
   validates :color, presence: true
  validates :position, presence: true, numericality: { only_integer: true }

  default_scope { order(position: :asc) }
end
