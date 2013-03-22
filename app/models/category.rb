class Category < ActiveRecord::Base
  attr_accessible :name, :duration
  validates :name, :duration, presence: true
  has_many :books
end
