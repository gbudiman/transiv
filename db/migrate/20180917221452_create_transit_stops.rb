class CreateTransitStops < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_stops, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.string                 :gtfs_id, null: false
      t.string                 :handle, null: false
      t.st_point               :lonlat, geographic: true
      t.belongs_to             :parent_station
      t.integer                :stop_type, null: false
    end

    add_index :transit_stops, :lonlat, using: :gist
  end
end
