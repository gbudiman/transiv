class TransitRoute < ApplicationRecord
  has_many :transit_trips, dependent: :destroy
  
  belongs_to :transit_agency
  validates :transit_agency, presence: true

  # def self.get _ids, agency: nil
  #   q = TransitRoute.joins(:transit_agency)

  #   if _ids == :all
  #   else
  #     ids = _ids.is_a?(Array) ? _ids : [_ids]
  #     q = q.where(id: ids)
  #   end

  #   if agency
  #     q = q.where('transit_agencies.id' => agency)
  #   end

  #   return q.select(:id, :handle, 
  #                   'transit_agencies.id AS agency_id', 
  #                   'transit_agencies.handle AS agency_handle')
  # end

  scope :paths_of, -> (id, at: Time.now, direction: 0) {
    joins_shape.joins_services(at)
      .where('transit_routes.id' => id)
      .where('transit_trips.direction' => direction)
      .reveal_coords
      .merge(TransitShape.order_by_sequence(direction == 0 ? :asc : :desc))
      .distinct
  }

  scope :joins_shape, -> {
    joins(transit_trips: :transit_shape)
  }

  scope :joins_services, -> (at) {
    joins(transit_trips: :transit_service)
      .merge(TransitService.active(at))
  }

  scope :reveal_coords, -> {
    select(%{
      ST_X(ST_AsText(lonlat)) AS lng,
      ST_Y(ST_AsText(lonlat)) AS lat,
      transit_shapes.sequence_id AS sequence_id
    })
  }
end
