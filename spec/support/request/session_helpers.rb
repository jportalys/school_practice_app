module Request
  module SessionHelpers
    def login(user)
      post auth_path, params: { email: user.email, password: "password" }
      hash = JSON.parse(response.body).with_indifferent_access
      return hash[:token]
    end
  end
end