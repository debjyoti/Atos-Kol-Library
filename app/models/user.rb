class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :das_id, :email, :password, :password_confirmation, :remember_me, :name, :phone_number, :manager, :max_book_count, :seat_number, :login
  # attr_accessible :title, :body
  attr_accessor :login
  has_many :books
  has_many :blocked_books, class_name: "Book", foreign_key: "blocked_by_id"
  validates :name, presence: true
  validates :das_id, presence: true, uniqueness: true

  has_many :members, :class_name => "User", :foreign_key => "admin_id"
  belongs_to :admin, :class_name => "User"

  has_many :book_issue_histories

  has_many :spendings

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

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(das_id) = :value OR lower(email) = :value", { :value => login.downcase } ]).first
    else
      where(conditions).first
    end
  end
end
