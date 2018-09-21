class CreateTransitStopTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_stop_times, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.string                 :transit_stop_id, null: false
      t.string                 :transit_trip_id, null: false
      t.integer                :arrival, null: false
      t.integer                :departure, null: false
      t.integer                :sequence, null: false
      t.string                 :handle, null: false
    end

    add_index :transit_stop_times, :transit_stop_id, name: 'stop_time_to_stop'
    add_index :transit_stop_times, :transit_trip_id, name: 'stop_time_to_trip'
    add_index :transit_stop_times, [:transit_trip_id, :transit_stop_id], unique: true
  end
end
