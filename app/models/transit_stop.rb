class TransitStop < ApplicationRecord
  has_many :transit_stop_times, dependent: :destroy

  scope :stop_only, -> {
    where(stop_type: 0)
  }

  scope :within, -> (lat:, lng:, distance: 200, at: Time.now) {
    stop_only.where(%{
      ST_Distance(lonlat, 'POINT(%f %f)') < %f
    } % [lng, lat, distance]).joins_stop_times(at).joins_routes.joins_services(at).humanize(lat, lng)
  }



  scope :joins_services, -> (at) {
    joins(transit_stop_times: { transit_trip: :transit_service })
      .merge(TransitService.active(at))
      #.active_day(at).active_service(at)
  }

  scope :joins_routes, -> {
    joins(transit_stop_times: { transit_trip: :transit_route })
  }

  scope :joins_stop_times, -> (at) {
    joins(:transit_stop_times).handle_wrap(at)
  }

  scope :handle_wrap, -> (at) {
    t = at.seconds_since_midnight % 86400
    t_pre = t - 10 * 60
    t_post = t + 30 * 60
    regular = stop_time_regular(t_pre, t_post)

    if (t_post > 86400)
      regular = regular.or(stop_time_wrap(t_post - 86400))
    end

    return regular
  }

  scope :stop_time_regular, -> (a, b) {
    where('transit_stop_times.departure' => a..b)
  }

  scope :stop_time_wrap, -> (overclock) {
    where(%{
      transit_stop_times.departure < %d
    } % [overclock])
  }

  scope :reveal_stop_times, -> {
    select('transit_stop_times.departure AS departure')
  }

  scope :reveal_route, -> {
    select(%{
      transit_routes.id AS route_id,
      transit_routes.shorthand AS route_shorthand,
      transit_routes.handle AS route_handle,
      transit_trips.direction AS route_direction
    })
  }

  scope :reveal_stop_info, -> {
    select('transit_stops.handle')
  }

  scope :humanize, -> (lat, lng) {
    select(%{
      transit_stops.id AS stop_id,
      ST_Distance(lonlat, 'POINT(%f %f)') AS distance_in_m,
      ST_X(ST_AsText(lonlat)) AS lng,
      ST_Y(ST_AsText(lonlat)) AS lat
    } % [lng, lat])
  }

  scope :sort_by_route_name, -> {
    #order('transit_routes.id, transit_trips.direction')
    order('transit_routes.gtfs_id')
  }

  scope :sort_by_route_departure, -> {
    order('transit_stop_times.departure ASC')
  }

  scope :filter_routes, -> (*routes) {
    merge(TransitRoute.routes_of_gtfs_id(routes))
  }
end
