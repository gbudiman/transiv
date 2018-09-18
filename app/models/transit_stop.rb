class TransitStop < ApplicationRecord
  acts_as_mappable default_units: :kms,
                   default_formula: :flat

  has_many :transit_stop_times, dependent: :destroy
end
