class CreateTransitStopTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_stop_times, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.belongs_to             :transit_stop, null: false
      t.belongs_to             :transit_trip, null: false
      t.time                   :arrival, null: false
      t.time                   :departure, null: false
      t.integer                :sequence, null: false
      t.string                 :handle, null: false
    end
  end
end
