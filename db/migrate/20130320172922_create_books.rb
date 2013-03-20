class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.string :category
      t.date :issued_on

      t.timestamps
    end
  end
end
