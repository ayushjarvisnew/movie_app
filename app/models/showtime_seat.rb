class ShowtimeSeat < ApplicationRecord
  belongs_to :showtime
  belongs_to :seat

  validates :showtime_id, uniqueness: { scope: :seat_id }
  # validates :seat_id, uniqueness: { scope: :showtime_id }

end
