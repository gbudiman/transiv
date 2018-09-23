class TransitShape < ApplicationRecord
  belongs_to :transit_trip
  validates :transit_trip, presence: true

  scope :order_by_sequence, -> (mode) {
    order(sequence_id: mode)
  }
end
