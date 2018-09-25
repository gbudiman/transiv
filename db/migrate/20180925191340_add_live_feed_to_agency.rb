class AddLiveFeedToAgency < ActiveRecord::Migration[5.2]
  def change
    add_column :transit_agencies, :live_feed, :string, null: true
  end
end
