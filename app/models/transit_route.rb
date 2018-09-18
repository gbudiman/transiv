class TransitRoute < ApplicationRecord
  has_many :transit_trips, dependent: :destroy
  
  belongs_to :transit_agency
  validates :transit_agency, presence: true
end
