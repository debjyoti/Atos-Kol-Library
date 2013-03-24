class AddBlockedByIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :blocked_by_id, :integer
  end
end
