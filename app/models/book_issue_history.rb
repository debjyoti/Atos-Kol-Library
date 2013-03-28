class BookIssueHistory < ActiveRecord::Base
  belongs_to :book
  belongs_to :user
  attr_accessible :book_id, :requested_on, :user_id
end
