class TransitStopTime < ApplicationRecord
  belongs_to :transit_stop
  validates :transit_stop, presence: true

  belongs_to :transit_trip
  validates :transit_trip, presence: true
  #has_many :transit_trip_stop_times, dependent: :destroy
end
