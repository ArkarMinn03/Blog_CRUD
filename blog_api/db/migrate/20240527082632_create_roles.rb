class CreateRoles < ActiveRecord::Migration[7.1]
  def up
    create_table :roles do |t|
      t.string :name
      t.integer :value

      t.timestamps
    end
  end
  def down
    drop_table :roles
  end
end
