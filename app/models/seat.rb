class Seat < ApplicationRecord

  acts_as_paranoid

  belongs_to :screen
  has_and_belongs_to_many :reservations, join_table: :reservations_seats

  validates :row, :seat_number, :seat_type, presence: true

  scope :active, -> { where(deleted_at: nil) }


end
