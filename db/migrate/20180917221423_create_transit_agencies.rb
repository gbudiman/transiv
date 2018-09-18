class CreateTransitAgencies < ActiveRecord::Migration[5.2]
  def change
    create_table :transit_agencies, id: false do |t|
      t.bigserial              :id, primary_key: true
      t.string                 :canon, null: false
      t.string                 :handle, null: false
    end
  end
end
