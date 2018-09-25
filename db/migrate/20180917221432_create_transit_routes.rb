class CreateTransitRoutes < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_routes, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.string                 :gtfs_id, null: false
      t.belongs_to             :transit_agency
      t.string                 :shorthand
      t.string                 :handle, null: false
      t.integer                :route_type, null: false
      t.string                 :bg_color
      t.string                 :fg_color
    end

    add_index :transit_routes, [:transit_agency_id, :gtfs_id], unique: true
    add_index :transit_routes, :gtfs_id
    add_foreign_key_constraint :transit_routes, :transit_agencies
  end
end
