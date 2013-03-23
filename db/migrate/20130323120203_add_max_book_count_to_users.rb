class AddMaxBookCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :max_book_count, :integer, default: 1
  end
end
