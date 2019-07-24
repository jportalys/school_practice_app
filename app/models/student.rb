class Student < ApplicationRecord
  has_secure_password
  validates :first_name, presence: true
  validates :middle_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :gender, presence: true , inclusion: { in: %w(male female) }
  validates :password, presence: true, confirmation: true
end
