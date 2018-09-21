class TransitTrip < ApplicationRecord
  belongs_to :transit_route
  validates :transit_route, presence: true

  has_many :transit_shapes, dependent: :destroy
  has_many :transit_services, dependent: :destroy
  has_many :transit_stop_times, dependent: :destroy
end
