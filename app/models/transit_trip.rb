class TransitTrip < ApplicationRecord
  belongs_to :transit_route
  validates :transit_route, presence: true

  belongs_to :transit_calendar
  validates :transit_calendar, presence: true

  belongs_to :transit_shape
  validates :transit_shape, presence: true 
end
