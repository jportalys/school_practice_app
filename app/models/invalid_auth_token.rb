class InvalidAuthToken < ApplicationRecord

  def self.crosscheck(token)
    raise JWT::VerificationError if self.find_by_token(token)
  end

  def self.cleanup
    self.where('expiry <= ?', Time.now).delete_all
  end
end