class CreateComments < ActiveRecord::Migration[7.1]
  def up
    create_table :comments do |t|
      t.string :comment
      t.references :blog, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
  def down
    drop_table :comments
  end
end
