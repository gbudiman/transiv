class CreateTransitShapes < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_shapes, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.string                 :gtfs_id, null: false
      t.st_point               :lonlat, geographic: true
      t.integer                :sequence_id, null: false
    end

    add_index :transit_shapes, [ :gtfs_id, :sequence_id ], unique: true
    add_index :transit_shapes, :lonlat, using: :gist
  end
end
