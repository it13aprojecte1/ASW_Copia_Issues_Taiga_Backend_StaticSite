class RenameTypeToIssueTypeInIssues < ActiveRecord::Migration[6.1]  # La versión puede variar
  def change
    rename_column :issues, :type, :issue_type
  end
end