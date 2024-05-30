class CreateUsers < ActiveRecord::Migration[7.1]
  def up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.integer :isBanned, default: 0
      t.integer :bannedPeriod, default: 0
      t.integer :role_value, null: false

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
