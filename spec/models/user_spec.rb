require 'rails_helper'

RSpec.describe User, type: :model do

  it "is valid with valid attributes" do
    user = User.new(
      name: "John Doe",
      email: "john@example.com",
      password: "Password123",
      password_confirmation: "Password123"
    )
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = User.new(email: "john@example.com", password: "Password123")
    expect(user).to_not be_valid
  end

  it "is invalid with duplicate email" do
    User.create!(name: "John", email: "john@example.com", password: "Password123", password_confirmation: "Password123")
    user2 = User.new(name: "Jane", email: "john@example.com", password: "Password123", password_confirmation: "Password123")
    expect(user2).to_not be_valid
  end
end
