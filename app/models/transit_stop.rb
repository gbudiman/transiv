class TransitStop < ApplicationRecord
  has_many :transit_stop_times, dependent: :destroy

  scope :humanize, -> (lat, lng) {
    select(%{
      transit_stops.id AS stop_id,
      ST_Distance(lonlat, 'POINT(%f %f)') AS distance_in_m,
      ST_X(ST_AsText(lonlat)) AS lng,
      ST_Y(ST_AsText(lonlat)) AS lat
    } % [lng, lat])
  }

  scope :stop_only, -> {
    where(stop_type: 0)
  }

  scope :within, -> (lat, lng, distance = 200) {
    stop_only.where(%{
      ST_Distance(lonlat, 'POINT(%f %f)') < %f
    } % [lng, lat, distance]).joins_stop_times.humanize(lat, lng)
  }

  scope :joins_route, -> {
    #joins(transit_stop_times: { transit_trip: :transit_route }).reveal_route
  }

  scope :joins_stop_times, -> {
    joins(:transit_stop_times).handle_wrap.reveal_stop_times
  }

  scope :handle_wrap, -> {
    t = Time.now.to_i % 86400
    t_pre = t - 10 * 60
    t_post = t + 10 * 60
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
      transit_routes.shorthand AS route_shorthand
    })
  }
end
