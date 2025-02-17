class CreateBlogs < ActiveRecord::Migration[7.1]
  def up
    create_table :blogs do |t|
      t.string :title
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
  def down
    drop_table :blogs
  end
end
