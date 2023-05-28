class Guest < ApplicationRecord
  has_many :reservations

  validates :email, presence: true, uniqueness: true
end
