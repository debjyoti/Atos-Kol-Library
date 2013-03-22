class AddDurationToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :duration, :integer
  end
end
