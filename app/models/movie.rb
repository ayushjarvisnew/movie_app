class Movie < ApplicationRecord

  acts_as_paranoid

  has_many :movie_tags, dependent: :destroy
  has_many :tags, through: :movie_tags
  has_many :showtimes, dependent: :destroy
  has_many :screens, through: :showtimes

  scope :active, -> { all }

  validates :title, :description, presence: true
  validates :rating,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 },
            allow_nil: true
end
