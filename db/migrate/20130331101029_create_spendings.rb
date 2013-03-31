class CreateSpendings < ActiveRecord::Migration
  def change
    create_table :spendings do |t|
      t.integer :user_id
      t.decimal :amount
      t.date :when
      t.string :desc

      t.timestamps
    end
  end
end
