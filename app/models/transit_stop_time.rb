class TransitStopTime < ApplicationRecord
  belongs_to :transit_stop
  validates :transit_stop, presence: true

  has_many :transit_trip_stop_times, dependent: :destroy
end
