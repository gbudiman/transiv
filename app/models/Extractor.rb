class Extractor
  def initialize bundle
    @bundle = bundle
    @h = {}
    @debug_mode = true

    extract_agency
    extract_routes
    extract_trips
    extract_routes
    extract_stops
    extract_stop_times
    extract_calendar

    load_all
  end

  def load_all
    ActiveRecord::Base.transaction do
      agency = TransitAgency.create! canon: @h[:canon], handle: @h[:handle]

      # @h[:routes].each do |route|
      #   # TransitRoute.create! canon: route[:canon],
      #   #                      handle: route[:handle],
      #   #                      route_type: route[:route_type],
      #   #                      bg_color: route[:bg_color],
      #   #                      fg_color: route[:fg_color],
      #   #                      transit_agency_id: agency.id
      #   #smart_insert klass: TransitRoute, data: route, assocs: { transit_agency: agency.id }
      # end

      route_ids = iterator_insert klass: TransitRoute, 
                                  data: @h[:routes], 
                                  assocs: { transit_agency: agency.id }

      ap route_ids
    end

    ap TransitRoute.all
    
  end

  def extract_agency
    get_iterator('agency.txt').each do |l|
      @h[:canon], @h[:handle] = l.split_comma_unquote 
    end
  end

  def extract_routes
    @h[:routes] = []
    get_iterator('routes.txt').each do |l|
      route_id, _, name, _, type, bg_color, fg_color = l.split_comma_unquote
      @h[:routes].push({
        canon: route_id,
        handle: name,
        route_type: type,
        bg_color: bg_color,
        fg_color: fg_color,

      })
    end 
  end

  def extract_trips
    @h[:trips] = {}
    get_iterator('trips.txt').each do |l|
      route_id, service_id, trip_id, headsign, direction, block_id, shape_id = l.split_comma_unquote
      @h[:trips][trip_id] ||= []
      @h[:trips][trip_id].push({
        route_id: route_id,
        service_id: service_id,
        direction: direction,
        block: block_id,
        shape_id: shape_id,
        headsign: headsign
      })
    end
  end

  def extract_shapes
    @h[:shapes] = {}
    get_iterator('shapes.txt').each do |l|
      shape_id, lat, long, sequence_id = l.split_comma_unquote
      @h[:shapes][shape_id] ||= []
      @h[:shapes][shape_id].push({
        lat: lat,
        long: long,
        sequence_id: sequence_id
      })
    end
  end

  def extract_stops
    @h[:stops] = []
    get_iterator('stops.txt').each do |l|
      stop_id, _, stop_name, _, lat, long, _, type, parent_canon = l.split_comma_unquote
      @h[:stops].push({
        canon: stop_id,
        handle: stop_name,
        lat: lat,
        long: long,
        type: type,
        parent_canon: parent_canon
      })
    end
  end

  def extract_stop_times
    @h[:stop_times] = []
    get_iterator('stop_times.txt').each do |l|
      trip_id, arrival, departure, stop_id, sequence, headsign = l.split_comma_unquote
      @h[:stop_times].push({
        trip_id: trip_id,
        arrival: arrival,
        departure: departure,
        stop_id: stop_id,
        sequence: sequence,
        headsign: headsign
      })
    end
  end

  def extract_calendar
    @h[:calendar] = {}
    get_iterator('calendar.txt').each do |l|
      service_id, m, t, w, r, f, s, u, st, ed = l.split_comma_unquote
      @h[:calendar][service_id] = {
        is_mon: m,
        is_tue: t,
        is_wed: w,
        is_thu: r,
        is_fri: f,
        is_sat: s,
        is_sun: u,
        start_date: Date.parse(st),
        end_date: Date.parse(ed)
      }
    end
  end

private
  def get_iterator file
    return IO.readlines(Rails.root.join('db', 'raw', @bundle, file)).drop(1)
  end

  def iterator_insert klass:, data:, assocs:
    rets = {}
    data.each do |datum|

      si = smart_insert(klass: klass, datum: datum, assocs: assocs)
      rets[si.canon] = si.id
    end

    return rets
  end

  def smart_insert klass:, datum:, assocs:
    buffer = datum
    assocs.each do |k, v|
      buffer["#{k}_id"] = v
    end
    
    return klass.create!(buffer)
  end
end

class String
  def split_comma_unquote
    return self.split(/\,/).map{ |x| x.gsub(/\"/, '') }
  end
end
