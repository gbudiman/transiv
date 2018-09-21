class CreateTransitRoutes < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_routes, id: false do |t|
      t.string                 :id, primary_key: true
      t.string                 :transit_agency_id, null: false
      t.string                 :handle, null: false
      t.integer                :route_type, null: false
      t.string                 :bg_color, null: false
      t.string                 :fg_color, null: false
    end

    add_index :transit_routes, :transit_agency_id, name: 'route_to_agency'
    add_index :transit_routes, :handle, unique: true
  end
end
