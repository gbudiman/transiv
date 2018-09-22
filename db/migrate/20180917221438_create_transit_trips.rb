class CreateTransitTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_trips, id: false do |t|
      t.string                 :id, primary_key: true
      t.string                 :transit_route_id, null: false
      t.string                 :transit_service_id, null: false
      t.string                 :transit_shape_id, null: false
      t.integer                :direction, null: false
      t.string                 :block, null: false
      t.string                 :headsign
    end

    add_index :transit_trips, :transit_route_id, name: 'trip_to_route'
    add_index :transit_trips, :transit_service_id, name: 'trip_to_service'
    add_index :transit_trips, :transit_shape_id, name: 'trip_to_shape'
  end
end
