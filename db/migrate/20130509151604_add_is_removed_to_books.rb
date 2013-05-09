class AddIsRemovedToBooks < ActiveRecord::Migration
  def change
    add_column :books, :is_removed, :boolean, :default => false
  end
end
