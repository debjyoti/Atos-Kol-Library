class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  attr_accessible :category_id, :description, :issued_on, :title, :user_id, :author
  validates :category_id, :title, :author, presence: true
end
