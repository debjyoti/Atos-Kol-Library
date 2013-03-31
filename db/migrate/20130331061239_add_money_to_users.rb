class AddMoneyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :money, :decimal, default: 0
  end
end
