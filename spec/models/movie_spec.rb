require 'rails_helper'

RSpec.describe Movie, type: :model do
  it "is valid with title, description, and release_date" do
    movie = Movie.new(title: "Avengers", description: "Superhero movie", release_date: Date.today)
    expect(movie).to be_valid
  end

  it "is invalid without a title" do
    movie = Movie.new(description: "Desc", release_date: Date.today)
    expect(movie).to_not be_valid
  end
end
