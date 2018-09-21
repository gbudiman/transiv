class CreateTransitServices < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_services, id: false do |t|
      t.string                 :id, primary_key: true
      t.boolean                :is_mon, null: false
      t.boolean                :is_tue, null: false
      t.boolean                :is_wed, null: false
      t.boolean                :is_thu, null: false
      t.boolean                :is_fri, null: false
      t.boolean                :is_sat, null: false
      t.boolean                :is_sun, null: false
      t.date                   :start_date, null: false
      t.date                   :end_date, null: false
    end
  end
end
