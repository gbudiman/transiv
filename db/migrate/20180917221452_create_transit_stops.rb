class CreateTransitStops < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_stops, id: false do |t|
      t.string                 :id, primary_key: true
      t.string                 :handle, null: false
      #t.decimal                :lat, precision: 10, scale: 6, null: false
      #t.decimal                :lng, precision: 10, scale: 6, null: false
      t.st_point               :lonlat, geographic: true
      t.string                 :parent_id, null: true
      t.string                 :stop_type, null: false
    end

    add_index :transit_stops, :lonlat, using: :gist
  end
end
