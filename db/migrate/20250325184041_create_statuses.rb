class CreateStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :statuses do |t|
      t.string :name
      t.string :color
      t.boolean :is_closed
      t.integer :position

      t.timestamps
    end
  end
end
