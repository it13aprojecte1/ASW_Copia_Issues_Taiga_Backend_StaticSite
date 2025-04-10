class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  validates :email, presence: true, uniqueness: true

  has_many :issues
  has_many :comments
  has_many :assigned_issues, class_name: 'Issue', foreign_key: 'assignee_id'
  has_and_belongs_to_many :watched_issues, class_name: 'Issue', join_table: 'issue_watchers'

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end
end