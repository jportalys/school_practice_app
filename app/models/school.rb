class School < ApplicationRecord
  
  has_one :user, as: :account
  has_many :courses

  validates :name, presence: true
end
