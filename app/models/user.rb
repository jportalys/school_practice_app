class User < ApplicationRecord
  has_secure_password
  belongs_to :account, polymorphic: true

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password, presence: true, confirmation: true 

  def account_type_is_school
    account_type == "School"
  end

  def account_type_is_student
    account_type == "Student"
  end
end
