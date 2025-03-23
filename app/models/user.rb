class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true

  has_many :issues
  has_many :comments
  has_many :assigned_issues, class_name: 'Issue', foreign_key: 'assignee_id'
  has_and_belongs_to_many :watched_issues, class_name: 'Issue', join_table: 'issue_watchers'
end