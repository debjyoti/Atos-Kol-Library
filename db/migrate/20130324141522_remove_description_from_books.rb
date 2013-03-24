class RemoveDescriptionFromBooks < ActiveRecord::Migration
  def up
    remove_column :books, :description
  end

  def down
    add_column :books, :description, :string
  end
end
