class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :blocked_by, class_name: "User", foreign_key: "blocked_by_id"
  belongs_to :category
  has_many :book_issue_histories
  attr_accessible :category_id, :description, :title, :author, :tag, :owner  #user_id, issued_on 
  validates :category_id, :title, :author, presence: true
  validates :tag, presence: true, uniqueness: true
end
