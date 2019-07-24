class JsonWebToken
  SECRET_KEY_BASE = Rails.application.secrets.secret_key_base
  
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY_BASE)
  end

  def self.decode(token)
    payload = JWT.decode(token, SECRET_KEY_BASE)[0]
    HashWithIndifferentAccess.new(payload)
  end
end