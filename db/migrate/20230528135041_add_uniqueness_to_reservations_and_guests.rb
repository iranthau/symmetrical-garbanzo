class AddUniquenessToReservationsAndGuests < ActiveRecord::Migration[7.0]
  def change
    add_index :reservations, :code, unique: true
    add_index :guests, :email, unique: true
  end
end
