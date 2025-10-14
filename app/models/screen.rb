class Screen < ApplicationRecord

  belongs_to :theatre
  has_many :showtimes, dependent: :destroy
  has_many :seats, dependent: :destroy


  validates :name, presence: true
  validates :total_seats, numericality: { greater_than: 0 }

  # Scopes
  scope :active, -> { where(deleted_at: nil) }

  # Returns globally available seats (not per showtime)
  def available_seats
    seats.where(available: true)
  end

  # Callbacks
  after_create :generate_seats

  private

  # Auto-generate seat records after screen creation
  def generate_seats
    return if total_seats.zero?

    rows = ("A".."Z").to_a
    seats_per_row = (total_seats.to_f / rows.size).ceil
    seats_created = 0

    rows.each do |row_letter|
      (1..seats_per_row).each do |seat_num|
        break if seats_created >= total_seats
        seats.create!(
          row: row_letter,
          seat_number: seat_num.to_s,
          seat_type: "Regular",
          available: true
        )
        seats_created += 1
      end
      break if seats_created >= total_seats
    end
  end
  end