class CreateTransitStops < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_stops, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.string                 :canon, null: false
      t.string                 :handle, null: false
      t.decimal                :lat, precision: 10, scale: 6, null: false
      t.decimal                :long, precision: 10, scale: 6, null: false
      t.integer                :parent_id, null: true
      t.integer                :type, null: false
      t.timestamps
    end

    add_index :transit_stops, [ :lat, :long ]
  end
end
