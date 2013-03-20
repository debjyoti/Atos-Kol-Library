class Book < ActiveRecord::Base
  attr_accessible :category, :description, :issued_on, :title, :user_id, :author
end
