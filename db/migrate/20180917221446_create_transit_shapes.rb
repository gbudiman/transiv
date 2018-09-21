class CreateTransitShapes < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_shapes, id: false do |t|
      t.string                 :id, primary_key: false
      t.decimal                :lat, precision: 10, scale: 6, null: false
      t.decimal                :long, precision: 10, scale: 6, null: false
      t.integer                :sequence_id, null: false
    end

    add_index :transit_shapes, [ :id, :sequence_id ], unique: true
    add_index :transit_shapes, [ :lat, :long ]
  end
end
