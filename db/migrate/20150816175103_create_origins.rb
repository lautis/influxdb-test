class CreateOrigins < ActiveRecord::Migration
  def change
    create_table :origins do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
    add_index :origins, :name, unique: true
  end
end
