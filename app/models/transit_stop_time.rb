class TransitStopTime < ApplicationRecord
  belongs_to :transit_trip
  validates :transit_trip, presence: true

  belongs_to :transit_stop
  validates :transit_stop, presence: true
end
