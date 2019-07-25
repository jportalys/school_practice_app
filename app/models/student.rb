class Student < ApplicationRecord

  has_one :user, as: :account

  validates :first_name, presence: true
  validates :middle_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true , inclusion: { in: %w(male female) }
end
