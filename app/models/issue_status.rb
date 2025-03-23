class IssueStatus < ApplicationRecord
  has_many :issues
  validates :name, presence: true, uniqueness: true
  validates :position, numericality: { only_integer: true }

  # Ordena los estados por posición por defecto
  default_scope { order(position: :asc) }
end
