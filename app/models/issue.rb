class Issue < ApplicationRecord
  belongs_to :user
  validates :subject, presence: true, length: { minimum: 1 }
  #validates :content, presence: true

  # Definició de "states" de forma manual ja que enum fa fatal.
  STATES = {
    new: 0,
    open: 1,
    on_hold: 2,
    resolved: 3,
    closed: 4
  }

  TYPES = {
    bug: 0,
    enhancement: 1,
    feature: 2,
    task: 3
  }

  SEVERITIES = {
    wishlist: 0,
    minor: 1,
    normal: 2,
    important: 3,
    critical: 4
  }

  PRIORITIES = {
    low: 0,
    normal: 1,
    high: 2
  }

  # Métodos para acceder a los estados como `issue.open?`
  STATES.each do |key, value|
    define_method("#{key}?") { self.state == value }
  end

  def state_name
    STATES.key(state)
  end

  def type_name
    TYPES.key(issue_type)
  end

  def severity_name
    SEVERITIES.key(severity)
  end

  def priority_name
    PRIORITIES.key(priority)
  end
end
