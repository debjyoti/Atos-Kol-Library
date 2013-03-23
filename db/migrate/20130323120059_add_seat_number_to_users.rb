class AddSeatNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :seat_number, :string
  end
end
