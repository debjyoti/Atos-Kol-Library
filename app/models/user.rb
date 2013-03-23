class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :das_id, :email, :password, :password_confirmation, :remember_me, :name, :phone_number, :manager, :max_book_count, :seat_number
  # attr_accessible :title, :body
  has_many :books
  validates :name, presence: true
  validates :das_id, presence: true, uniqueness: true

  has_many :members, :class_name => "User", :foreign_key => "admin_id"
  belongs_to :admin, :class_name => "User"

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super
    end
  end

  after_create :send_admin_mail
  def send_admin_mail
    UserMailer.approval_notify(self).deliver
  end

end
