class TransitRoute < ApplicationRecord
  has_many :transit_trips, dependent: :destroy
  
  belongs_to :transit_agency
  validates :transit_agency, presence: true

  scope :routes_of, -> (id, agency_id: nil) {
    r = routes(id)
    if agency_id
      r = r.restrict_agency(agency_id)
    end

    return r
  }

  scope :routes, -> (id) {
    if (id == :all)
    else
      where(id: id)
    end
  }

  scope :restrict_agency, -> (agency_id) {
    joins_agency.where('transit_agencies.id' => agency_id)
  }

  scope :joins_agency, -> {
    joins(:transit_agency)
  }

  scope :get_aggregate_paths, -> (at: Time.now.localtime) {
    joins_shapes.joins_services(at).distinct
  }

  scope :get_aggregate_stops, -> (at: Time.now.localtime) {
    joins_stops.joins_services(at).distinct
  }

  scope :joins_shapes, -> {
    joins(transit_trips: :transit_shape)
  }

  scope :joins_stops, -> {
    joins(transit_trips: { transit_stop_times: :transit_stop })
  }

  scope :joins_services, -> (at) {
    joins(transit_trips: :transit_service)
      .merge(TransitService.active(at))
  }


  scope :reveal_coords, -> {
    select(%{
      ST_X(ST_AsText(lonlat)) AS lng,
      ST_Y(ST_AsText(lonlat)) AS lat
    })
  }

  scope :reveal_stop_info, -> {
    reveal_stop_coords.reveal_stop_name
  }

  scope :reveal_stop_coords, -> {
    select(%{
      ST_X(ST_AsText(transit_stops.lonlat)) AS lng,
      ST_Y(ST_AsText(transit_stops.lonlat)) AS lat
    })
  }

  scope :reveal_stop_name, -> {
    select('transit_stops.handle,
            transit_routes.id')
  }
end
