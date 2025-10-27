class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :showtime

  has_and_belongs_to_many :seats, join_table: :reservations_seats

  validates :payment_status, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(deleted_at: nil)}

  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end
end


