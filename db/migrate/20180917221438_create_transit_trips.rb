class CreateTransitTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_trips, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.belongs_to             :transit_route
      t.belongs_to             :transit_calendar
      t.belongs_to             :transit_shape
      t.boolean                :direction, null: false
      t.integer                :block, null: false
      t.string                 :headsign
    end
  end
end
