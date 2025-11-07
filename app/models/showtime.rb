class Showtime < ApplicationRecord
  belongs_to :movie
  belongs_to :screen
  has_one :theatre, through: :screen

  has_many :reservations
  has_many :users, through: :reservations

  has_many :showtime_seats, dependent: :destroy
  has_many :seats, through: :showtime_seats

  validates :start_time, :end_time, :language, presence: true
  validates :available_seats, numericality: { greater_than_or_equal_to: 0 }
  validate :end_after_start

  scope :active, -> { where(deleted_at: nil) }
  scope :upcoming, -> { where("start_time >= ?", Time.current).order(:start_time) }

  before_create :set_available_seats
  after_create :initialize_showtime_seats

  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end

  # ✅ Update available seats using ShowtimeSeats now
  def update_available_seats!
    booked_seats = showtime_seats.where(available: false).count
    update!(available_seats: screen.total_seats - booked_seats)
  end

  private

  def end_after_start
    return if end_time.blank? || start_time.blank?
    errors.add(:end_time, "must be after the start time") if end_time <= start_time
  end

  def set_available_seats
    self.available_seats = screen.total_seats if screen.present?
  end

  def initialize_showtime_seats
    screen.seats.find_each do |seat|
      ShowtimeSeat.create!(showtime: self, seat: seat, available: true)
    end
  end
end
