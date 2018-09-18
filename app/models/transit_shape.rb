class TransitShape < ApplicationRecord
  acts_as_mappable default_units: :kms,
                   default_formula: :flat

  has_many :transit_trips, dependent: :destroy
end
