class CreateTransitStopTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_stop_times, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.belongs_to             :transit_stop
      t.belongs_to             :transit_trip
      t.integer                :arrival, null: false
      t.integer                :departure, null: false
      t.integer                :sequence, null: false
      t.string                 :handle, null: false
    end
  end
end
