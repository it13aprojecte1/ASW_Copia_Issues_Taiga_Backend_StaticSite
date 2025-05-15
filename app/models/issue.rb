class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :status
  belongs_to :issue_type
  belongs_to :severity
  belongs_to :priority

  has_many :comments, dependent: :destroy

  has_many_attached :attachments, service: :amazon

  validates :subject, presence: true, length: { minimum: 1 }
  #validates :deadline, presence: true

  belongs_to :assignee, class_name: 'User', optional: true
  has_and_belongs_to_many :watchers, class_name: 'User', join_table: 'issue_watchers'

  # Scopes para filtrado
  scope :filtrar_por_titulo, ->(titulo) { where("subject LIKE ?", "%#{titulo}%") }
  scope :filtrar_por_descripcion, ->(descripcion) { where("content LIKE ?", "%#{descripcion}%") }

  # Scopes por ID
  scope :por_tipo, ->(issue_type_id) { where(issue_type_id: issue_type_id) }
  scope :por_severidad, ->(severity_id) { where(severity_id: severity_id) }
  scope :por_prioridad, ->(priority_id) { where(priority_id: priority_id) }
  scope :por_estado, ->(status_id) { where(status_id: status_id) }
  scope :por_creador, ->(user_id) { where(user_id: user_id) }
  scope :por_asignado, ->(assignee_id) { where(assignee_id: assignee_id) }

  # Scopes por nombre
  scope :por_tipo_nombre, ->(nombre) { joins(:issue_type).where("lower(issue_types.name) = ?", nombre.downcase) }
  scope :por_severidad_nombre, ->(nombre) { joins(:severity).where("lower(severities.name) = ?", nombre.downcase) }
  scope :por_prioridad_nombre, ->(nombre) { joins(:priority).where("lower(priorities.name) = ?", nombre.downcase) }

  # Scope mejorado para estado que maneja diferentes formatos
  scope :por_estado_nombre, ->(nombre) do
    # Normalizar el nombre (quitar espacios, guiones bajos, etc.)
    nombre_normalizado = nombre.downcase.gsub(/[\s_-]/, '')
    joins(:status).where(
      "LOWER(REPLACE(REPLACE(REPLACE(statuses.name, ' ', ''), '_', ''), '-', '')) = ?",
      nombre_normalizado
    )
  end
end