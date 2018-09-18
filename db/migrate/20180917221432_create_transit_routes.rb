class CreateTransitRoutes < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_routes, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.belongs_to             :transit_agency
      t.string                 :canon, null: false
      t.string                 :handle, null: false
      t.integer                :route_type, null: false
      t.string                 :bg_color, null: false
      t.string                 :fg_color, null: false
    end
  end
end
