class CreateTransitPredictions < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_predictions, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.belongs_to             :transit_trip
      t.belongs_to             :transit_stop
      t.integer                :predictions, array: true, null: false
      t.timestamps
    end

    add_index :transit_predictions, [:transit_stop_id, :transit_trip_id], unique: true, name: 'unique_prediction_stop_trip_constraint'
    add_index :transit_predictions, [:transit_trip_id, :transit_stop_id], name: 'precition_trip_stop'
  end
end
