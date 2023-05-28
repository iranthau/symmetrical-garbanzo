class CreateGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.column :phone_numbers, :string, array: true, default: []

      t.timestamps
    end
  end
end
