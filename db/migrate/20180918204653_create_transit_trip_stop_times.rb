class CreateTransitTripStopTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_trip_stop_times, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.belongs_to             :transit_trip
      t.belongs_to             :transit_stop_time
    end
  end
end
