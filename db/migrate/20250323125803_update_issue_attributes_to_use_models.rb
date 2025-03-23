class UpdateIssueAttributesToUseModels < ActiveRecord::Migration[8.0]
  def change
    # Añadir nuevas referencias
    add_reference :issues, :issue_status, foreign_key: true
    add_reference :issues, :issue_type, foreign_key: true
    add_reference :issues, :issue_severity, foreign_key: true
    add_reference :issues, :issue_priority, foreign_key: true

    # Eliminar columnas antiguas (después de migrar los datos)
    remove_column :issues, :state
    remove_column :issues, :issue_type
    remove_column :issues, :severity
    remove_column :issues, :priority
  end
end