class Screen < ApplicationRecord

  acts_as_paranoid

  belongs_to :theatre
  has_many :showtimes, dependent: :destroy
  has_many :seats, dependent: :destroy

  validates :name, presence: true
  validates :total_seats, numericality: { greater_than: 0 }

  scope :active, -> { where(deleted_at: nil) }

  def available_seats
    seats.where(available: true)
  end

  after_create :generate_seats

  private

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