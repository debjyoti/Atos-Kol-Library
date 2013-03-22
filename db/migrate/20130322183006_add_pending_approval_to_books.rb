class AddPendingApprovalToBooks < ActiveRecord::Migration
  def change
    add_column :books, :pending_approval, :boolean
  end
end
