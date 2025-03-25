class CreateSeverities < ActiveRecord::Migration[8.0]
  def change
    create_table :severities do |t|
      t.string :name
      t.string :color
      t.integer :position

      t.timestamps
    end
  end
end
