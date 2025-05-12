class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  validates :email, presence: true, uniqueness: true
  validates :api_key, uniqueness: true, allow_nil: true

  before_create :generate_api_key

  has_many :issues
  has_many :comments
  has_many :assigned_issues, class_name: 'Issue', foreign_key: 'assignee_id'
  has_and_belongs_to_many :watched_issues, class_name: 'Issue', join_table: 'issue_watchers'
  has_one_attached  :avatar

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end

  # Override password required method to make it optional only for GitHub users
  def password_required?
    # No requiere contraseña si el usuario se autenticó con GitHub
    provider.present? && uid.present? ? false : super
  end

  # Obtiene la API key actual o genera una nueva si no existe
  def get_api_key
    if api_key.nil?
      generate_api_key
      save
    end
    api_key
  end

  private

  def generate_api_key
    self.api_key = loop do
      random_key = SecureRandom.base64(24).tr('+/=', 'xyz')
      break random_key unless User.exists?(api_key: random_key)
    end
  end
end