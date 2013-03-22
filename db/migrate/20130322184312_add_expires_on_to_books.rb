class AddExpiresOnToBooks < ActiveRecord::Migration
  def change
    add_column :books, :expires_on, :date
  end
end
