class TransitTrip < ApplicationRecord
  belongs_to :transit_route
  validates :transit_route, presence: true

  #has_many :transit_shapes, dependent: :destroy
  belongs_to :transit_shape, primary_key: :id
  belongs_to :transit_service, primary_key: :id
  has_many :transit_stop_times, dependent: :destroy

  def self.get_associated klass, scoped: nil, uniq: 
    selector = uniq.map{ |x| "#{klass}.#{x} " }.join(', ')
    self.joins(:transit_route)
        .joins(klass.to_s.singularize.to_sym)
        .where(scoped)
        .select(selector)
        .distinct
  end
end
