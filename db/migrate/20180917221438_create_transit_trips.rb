class CreateTransitTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_trips, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.string                 :gtfs_id, null: false
      t.belongs_to             :transit_route
      t.belongs_to             :transit_service
      t.belongs_to             :transit_shape
      t.integer                :direction, null: false
      t.string                 :block, null: false
      t.string                 :headsign
    end

    add_index :transit_trips, :gtfs_id
    add_index :transit_trips, [:transit_route_id, :gtfs_id, :direction], unique: true, name: 'unique_transit_trip_constraint'
    add_foreign_key_constraint :transit_trips, :transit_services
    add_foreign_key_constraint :transit_trips, :transit_routes
    add_foreign_key_constraint :transit_trips, :transit_shapes
  end
end
