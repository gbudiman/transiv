class TransitStop < ApplicationRecord
  has_many :transit_stop_times, dependent: :destroy

  def self.get_stops from:, within: 0.2
    return TransitStop.within(within, origin: from).where(stop_type: 0)#.order('distance ASC')
  end
end
