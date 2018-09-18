class TransitCalendar < ApplicationRecord
  has_many :transit_trips, dependent: :destroy
end
