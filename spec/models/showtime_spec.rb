# require 'rails_helper'
#
# RSpec.describe Showtime, type: :model do
#   let(:movie)  { Movie.create!(title: "Movie", description: "Desc", release_date: Date.today) }
#   let(:theatre){ Theatre.create!(
#     name: "Big Theatre",
#     address: "123 Main St",
#     city: "Delhi",
#     state: "Delhi",
#     country: "India"
#   ) }
#   let(:screen) { Screen.create!(name: "Screen 1", theatre: theatre, total_seats: 100) }
#
#   it "is valid with movie, screen, start_time, end_time, and language" do
#     showtime = Showtime.new(
#       movie: movie,
#       screen: screen,
#       start_time: DateTime.now + 1.hour,
#       end_time: DateTime.now + 2.hours,
#       language: "English"
#     )
#     expect(showtime).to be_valid
#   end
#
#   it "is invalid without a movie" do
#     showtime = Showtime.new(
#       screen: screen,
#       start_time: DateTime.now + 1.hour,
#       end_time: DateTime.now + 2.hours,
#       language: "English"
#     )
#     expect(showtime).to_not be_valid
#   end
#
#   it "is invalid without a screen" do
#     showtime = Showtime.new(
#       movie: movie,
#       start_time: DateTime.now + 1.hour,
#       end_time: DateTime.now + 2.hours,
#       language: "English"
#     )
#     expect(showtime).to_not be_valid
#   end
#
#   it "is invalid if end_time is before start_time" do
#     showtime = Showtime.new(
#       movie: movie,
#       screen: screen,
#       start_time: DateTime.now + 2.hours,
#       end_time: DateTime.now + 1.hour,
#       language: "English"
#     )
#     expect(showtime).to_not be_valid
#   end
# end
require 'rails_helper'

RSpec.describe Showtime, type: :model do
  let(:movie)  { Movie.create!(title: "Movie", description: "Desc", release_date: Date.today) }
  let(:theatre){ Theatre.create!(
    name: "Big Theatre",
    address: "123 Main St",
    city: "Delhi",
    state: "Delhi",
    country: "India"
  ) }
  let(:screen) { Screen.create!(name: "Screen 1", theatre: theatre, total_seats: 100) }

  it "is valid with movie, screen, start_time, end_time, language, and available_seats" do
    showtime = Showtime.new(
      movie: movie,
      screen: screen,
      start_time: DateTime.now + 1.hour,
      end_time: DateTime.now + 2.hours,
      language: "English",
      available_seats: screen.total_seats
    )
    expect(showtime).to be_valid
  end

  it "is invalid without a movie" do
    showtime = Showtime.new(
      screen: screen,
      start_time: DateTime.now + 1.hour,
      end_time: DateTime.now + 2.hours,
      language: "English",
      available_seats: screen.total_seats
    )
    expect(showtime).to_not be_valid
  end

  it "is invalid without a screen" do
    showtime = Showtime.new(
      movie: movie,
      start_time: DateTime.now + 1.hour,
      end_time: DateTime.now + 2.hours,
      language: "English",
      available_seats: 100
    )
    expect(showtime).to_not be_valid
  end

  it "is invalid if end_time is before start_time" do
    showtime = Showtime.new(
      movie: movie,
      screen: screen,
      start_time: DateTime.now + 2.hours,
      end_time: DateTime.now + 1.hour,
      language: "English",
      available_seats: screen.total_seats
    )
    expect(showtime).to_not be_valid
  end
end
