require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  describe "POST #signup" do
    it "creates a new user" do
      post :signup, params: { name: "Alice", email: "alice@example.com", password: "Password123", password_confirmation: "Password123" }
      expect(response).to have_http_status(:created)
    end
  end
end
