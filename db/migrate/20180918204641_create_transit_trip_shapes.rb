class CreateTransitTripShapes < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_trip_shapes, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.belongs_to             :transit_trip
      t.belongs_to             :transit_shape
    end
  end
end
