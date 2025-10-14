class User < ApplicationRecord
  has_secure_password

  has_many :reservations
  has_many :showtimes, through: :reservations

  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { password.present? }

  def role
    is_admin ? "admin" : "user"
  end
end
