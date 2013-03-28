class CreateBookIssueHistories < ActiveRecord::Migration
  def change
    create_table :book_issue_histories do |t|
      t.integer :book_id
      t.integer :user_id
      t.date :requested_on
      t.date :issued_on
      t.date :returned_on

      t.timestamps
    end
  end
end
