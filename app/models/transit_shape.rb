class TransitShape < ApplicationRecord
  belongs_to :transit_trip
  validates :transit_trip, presence: true
end
