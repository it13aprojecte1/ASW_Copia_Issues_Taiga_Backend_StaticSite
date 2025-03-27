class AddDeadlineToIssues < ActiveRecord::Migration[8.0]
  def change
    add_column :issues, :deadline, :date
  end
end
