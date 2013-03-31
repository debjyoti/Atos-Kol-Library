class Spending < ActiveRecord::Base
  attr_accessible :amount, :desc, :user_id, :when
  validates_presence_of :amount, :desc, :user_id
  belongs_to :user
end
