class TransitTripStopTime < ApplicationRecord
  belongs_to :transit_trip
  validates :transit_trip, presence: true

  belongs_to :transit_stop_time
  validates :transit_stop_time, presence: true
end
