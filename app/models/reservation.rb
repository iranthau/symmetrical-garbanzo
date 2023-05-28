class Reservation < ApplicationRecord
  belongs_to :guest

  validates :code, presence: true, uniqueness: true
end
