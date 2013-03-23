class ChangeUsersAddDefaultFine < ActiveRecord::Migration
  def change
    change_column :users, :fine, :decimal, :default => 0
  end
end
