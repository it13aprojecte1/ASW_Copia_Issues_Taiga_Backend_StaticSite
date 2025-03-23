class AddAssigneeToIssues < ActiveRecord::Migration[8.0]
  def change
    add_reference :issues, :assignee, foreign_key: { to_table: :users }, null: true
  end
end
