class School < ApplicationRecord

  has_one :user, as: :account
  has_many :courses
  has_many :enrollees, through: :courses, class_name: "Enrollement"

  validates :name, presence: true
end
