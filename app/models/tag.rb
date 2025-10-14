class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :movie_tags
  has_many :movies, through: :movie_tags
end
