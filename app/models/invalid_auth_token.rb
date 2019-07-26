class InvalidAuthToken < ApplicationRecord

  def self.crosscheck(token)
    raise ActiveRecord::RecordNotFound if self.find_by_token(token)
  end
end