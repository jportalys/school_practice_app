class Student < ApplicationRecord

  has_one :user, as: :account
  has_many :enrollments
  has_many :courses, through: :enrollments
  has_many :schools, through: :courses

  validates :first_name, presence: true
  validates :middle_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true , inclusion: { in: %w(male female) }
end
