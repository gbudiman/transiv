class TransitPrediction < ApplicationRecord
  belongs_to :transit_stop
  validates :transit_stop, presence: true

  belongs_to :transit_trip
  validates :transit_trip, presence: true
end
