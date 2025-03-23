class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :issue_status
  belongs_to :issue_type
  belongs_to :issue_severity
  belongs_to :issue_priority

  has_many :comments, dependent: :destroy

  validates :subject, presence: true, length: { minimum: 1 }

  belongs_to :assignee, class_name: 'User', optional: true
  has_and_belongs_to_many :watchers, class_name: 'User', join_table: 'issue_watchers'
end