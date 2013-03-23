class AddManagerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :manager, :string
  end
end
