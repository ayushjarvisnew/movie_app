require 'rails_helper'

RSpec.describe Seat, type: :model do
  let(:theatre){ Theatre.create!(
    name: "Big Theatre",
    address: "123 Main St",
    city: "Delhi",
    state: "Delhi",
    country: "India"
  ) }

  let(:screen) { Screen.create!(name: "Screen 1", theatre: theatre, total_seats: 100) }

  it "is valid with row, seat_number, seat_type, price, and screen" do
    seat = Seat.new(
      row: "A",
      seat_number: 1,
      seat_type: "Regular",
      price: 100,
      available: true,
      screen: screen
    )
    expect(seat).to be_valid
  end

  it "is invalid without row" do
    seat = Seat.new(
      seat_number: 1,
      seat_type: "Regular",
      price: 100,
      screen: screen
    )
    expect(seat).to_not be_valid
  end

  it "is invalid without a screen" do
    seat = Seat.new(
      row: "A",
      seat_number: 1,
      seat_type: "Regular",
      price: 100
    )
    expect(seat).to_not be_valid
  end

  it "is invalid without seat_type" do
    seat = Seat.new(
      row: "A",
      seat_number: 1,
      price: 100,
      screen: screen
    )
    expect(seat).to_not be_valid
  end
end
