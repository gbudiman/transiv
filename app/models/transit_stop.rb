class TransitStop < ApplicationRecord
  has_many :transit_stop_times, dependent: :destroy

  scope :humanize, -> (lat, lng) {
    select(%{
      ST_Distance(lonlat, 'POINT(%f %f)') AS dist_in_m,
      ST_X(ST_AsText(lonlat)) AS lng,
      ST_Y(ST_AsText(lonlat)) AS lat
    } % [lng, lat])
  }

  scope :stop_only, -> {
    where(stop_type: 0)
  }

  scope :within, -> (lat, lng, distance = 200) {
    stop_only.where(%{
      ST_Distance(lonlat, 'POINT(%f %f)') < %f
    } % [lng, lat, distance]).humanize(lat, lng)
  }

  def self.get_stops from:, within: 0.2
    return TransitStop.within(within, origin: from).where(stop_type: 0)#.order('distance ASC')
  end
end
