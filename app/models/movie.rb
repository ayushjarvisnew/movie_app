class Movie < ApplicationRecord
  has_many :movie_tags
  has_many :tags, through: :movie_tags
  has_many :screens, through: :showtimes
  has_many :showtimes, dependent: :destroy

  validates :title, :description, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }, allow_nil: true


  scope :active, -> { where(deleted_at: nil) }


  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end

end
