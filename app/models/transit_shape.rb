class TransitShape < ApplicationRecord
  acts_as_mappable default_units: :kms,
                   default_formula: :flat

  belongs_to :transit_trip
  validates :transit_trip, presence: true
end
