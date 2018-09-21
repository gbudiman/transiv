class TransitShape < ApplicationRecord
  acts_as_mappable default_units: :kms,
                   default_formula: :flat

  has_many :transit_trip_shapes, dependent: :destroy
end
