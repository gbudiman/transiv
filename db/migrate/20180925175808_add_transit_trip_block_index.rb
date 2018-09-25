class AddTransitTripBlockIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :transit_trips, :block, unique: false
  end
end
