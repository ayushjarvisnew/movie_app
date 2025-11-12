class User < ApplicationRecord
  has_secure_password

  acts_as_paranoid
  has_many :reservations,dependent: :destroy
  has_many :showtimes, through: :reservations

  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { password.present? }
  validates :phone, presence: true, format: { with: /\A\d{10}\z/, message: "must be exactly 10 digits" }

end
