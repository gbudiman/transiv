class TransitTripShape < ApplicationRecord
  belongs_to :transit_trip
  validates :transit_trip, presence: true

  belongs_to :transit_shape
  validates :transit_shape, presence: true
end
