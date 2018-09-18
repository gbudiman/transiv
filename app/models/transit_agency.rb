class TransitAgency < ApplicationRecord
  has_many :transit_routes, dependent: :destroy
end
