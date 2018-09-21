class TransitService < ApplicationRecord
  has_many :transit_trip_calendars, dependent: :destroy
end
