class TransitTripCalendar < ApplicationRecord
  belongs_to :transit_trip
  validates :transit_trip, presence: true

  belongs_to :transit_calendar
  validates :transit_calendar, presence: true
end
