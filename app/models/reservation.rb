class Reservation < ApplicationRecord

  acts_as_paranoid

  belongs_to :user
  belongs_to :showtime

  has_and_belongs_to_many :seats, join_table: :reservations_seats

  validates :payment_status, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

  validate :showtime_cannot_be_in_the_past, on: :create

  scope :active, -> { where(deleted_at: nil)}
  scope :expired_pending, -> { where(payment_status: "pending").where("created_at < ?", 15.minutes.ago) }

  def self.cleanup_expired
    expired_pending.find_each(&:destroy)
  end
  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end
  private

  def showtime_cannot_be_in_the_past
    if showtime && showtime.start_time < Time.current
      errors.add(:showtime, "cannot be in the past")
    end
  end
end


