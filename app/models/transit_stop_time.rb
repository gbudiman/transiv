class TransitStopTime < ApplicationRecord
  belongs_to :transit_stop
  validates :transit_stop, presence: true

  #has_many :transit_stops

  belongs_to :transit_trip
  validates :transit_trip, presence: true
  
  #has_one :transit_trips
end
