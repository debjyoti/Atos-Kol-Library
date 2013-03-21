class AddNameAndFineToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :fine, :decimal
  end
end
