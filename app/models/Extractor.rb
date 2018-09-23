class Extractor
  def initialize bundle
    @bundle = bundle
    @h = { statistics: {} }
  end

  def execute!
    _execute_extract
    load_all
  end

  def _execute_extract
    extract_agency
    extract_routes
    extract_trips
    extract_shapes
    extract_stops
    extract_stop_times
    extract_service
  end

  def accountability
    is_accountable = true
    scoped = { 'transit_routes.transit_agency_id' => @h[:id] }
    _execute_extract
    
    persistance = {
      transit_routes: TransitRoute.joins(:transit_agency).where(scoped).count,
      transit_trips: TransitTrip.joins(transit_route: :transit_agency).where(scoped).count,
      transit_services: TransitTrip.get_associated(:transit_services, scoped: scoped, uniq: [:id]).to_a.count,
      transit_shapes: TransitTrip.get_associated(:transit_shapes, scoped: scoped, uniq: [:id, :sequence_id]).to_a.count,
      transit_stop_times: TransitTrip.joins(:transit_stop_times).joins(:transit_route).where(scoped).count,
      transit_stops: TransitTrip.joins(transit_stop_times: :transit_stop).select('transit_stops.id').distinct.count
    }

    
    @h[:statistics].each do |stat, value|
      is_accountable = is_accountable and (persistance[stat] == value)
    end

    return is_accountable
  end

  def load_all
    ActiveRecord::Base.transaction do
      puts "Loading data for #{@h[:id]}..."
      puts '--------------------------------'
      TransitAgency.find_or_initialize_by(id: @h[:id], handle: @h[:handle]).save!
      insert using: TransitRoute, lookup: [:transit_agency_id, :id]
      insert using: TransitService
      insert using: TransitShape, lookup: [:id, :sequence_id]
      insert using: TransitTrip
      insert using: TransitStop
      insert using: TransitStopTime, 
             lookup: [:transit_trip_id, :transit_stop_id],
             transform: { arrival: :time_to_numeric,
                          departure: :time_to_numeric }
    end
  end

  def extract_agency
    get_iterator('agency.txt').each do |l|
      @h[:id], @h[:handle] = l.split_comma_unquote 
    end
  end

  def extract_routes
    @h[:transit_routes] = []
    get_iterator('routes.txt').each do |l|
      id, shorthand, name, _, type, bg_color, fg_color = l.split_comma_unquote
      @h[:transit_routes].push({
        id: id,
        shorthand: shorthand,
        handle: name,
        route_type: type.to_i,
        bg_color: bg_color,
        fg_color: fg_color,
        transit_agency_id: @h[:id]
      })
    end 

    @h[:statistics][:transit_routes] = @h[:transit_routes].count
  end

  def extract_trips
    @h[:transit_trips] = []
    get_iterator('trips.txt').each do |l|
      route_id, service_id, trip_id, headsign, direction, block_id, shape_id = l.split_comma_unquote
      @h[:transit_trips].push({
        id: trip_id,
        transit_route_id: route_id,
        transit_service_id: service_id,
        transit_shape_id: shape_id,
        direction: direction,
        block: block_id,
        headsign: headsign
      })
    end

    @h[:statistics][:transit_trips] = @h[:transit_trips].count
  end

  def extract_shapes
    @h[:transit_shapes] = []
    get_iterator('shapes.txt').each do |l|
      id, lat, lng, sequence_id = l.split_comma_unquote
      @h[:transit_shapes].push({
        id: id,
        lonlat: "ST_GeomFromText('POINT(#{lng} #{lat})', 4326)",
        sequence_id: sequence_id
      })
    end

    @h[:statistics][:transit_shapes] = @h[:transit_shapes].count
  end

  def extract_stops
    stop_count = 0
    @h[:transit_stops] = []
    get_iterator('stops.txt').each do |l|
      id, _, name, _, lat, lng, _, type, parent_id = l.split_comma_unquote
      stop_count = stop_count + (type == '0' ? 1 : 0)
      @h[:transit_stops].push({
        id: id,
        handle: name,
        lonlat: "ST_GeomFromText('POINT(#{lng} #{lat})', 4326)",
        stop_type: type || 0,
        parent_id: parent_id
      })
    end

    @h[:statistics][:transit_stops] = stop_count
  end

  def extract_stop_times
    @h[:transit_stop_times] = []
    get_iterator('stop_times.txt').each do |l|
      trip_id, arrival, departure, stop_id, sequence, headsign = l.split_comma_unquote
      @h[:transit_stop_times].push({
        transit_trip_id: trip_id,
        transit_stop_id: stop_id,
        arrival: arrival,
        departure: departure,
        sequence: sequence,
        handle: headsign
      })
    end

    @h[:statistics][:transit_stop_times] = @h[:transit_stop_times].count
  end

  def extract_service
    @h[:transit_services] = []
    get_iterator('calendar.txt').each do |l|
      id, m, t, w, r, f, s, u, st, ed = l.split_comma_unquote
      @h[:transit_services].push({
        id: id,
        is_mon: m,
        is_tue: t,
        is_wed: w,
        is_thu: r,
        is_fri: f,
        is_sat: s,
        is_sun: u,

        start_date: Date.parse(st),
        end_date: Date.parse(ed)
      })
    end

    @h[:statistics][:transit_services] = @h[:transit_services].count
  end

private
  def get_iterator file
    return IO.readlines(Rails.root.join('db', 'raw', @bundle, file)).drop(1)
  end

  def insert using:, lookup: [], transform: {}
    data = using.table_name.to_sym
    anchor = @h[data].first
    sql = "INSERT INTO #{using.table_name} (#{anchor.keys.join(', ')}) VALUES "
    datatypes = []
    conflict_keys = []
    conflict_updates = []
    len = @h[data].length
    mod = [len / 16, 1000].max

    anchor.keys.each do |key|
      case transform[key]
      when nil
        datatypes.push(using.column_for_attribute(key).type)
      else
        datatypes.push(transform[key])
      end

      if lookup.empty?
        if key == :id then conflict_keys.push(key)
        else conflict_updates.push(key)
        end
      else
        if lookup.include?(key) then conflict_keys.push(key)
        else conflict_updates.push(key)
        end        
      end
    end

    vals = []
    # ap datatypes
    # ap conflict_keys
    # ap conflict_updates

    @h[data].each_with_index do |datum, index|
      cells = []
      datum.values.each_with_index do |value, vindex|
        case datatypes[vindex]
        when :string
          cells.push ActiveRecord::Base.connection.quote(value)
        when :boolean
          cells.push (value == '1' ? 'TRUE' : 'FALSE')
        when :date
          cells.push "to_date('#{value}', 'YYYY-MM-DD')"
        when :time_to_numeric
          cells.push time_to_numeric(value)
        else
          cells.push value
        end
      end

      vals.push('(' + cells.join(', ') + ')')

      if index == 0
        puts "> Begin load into #{using.to_s}..."
      elsif index % mod == 0
        puts "  - Loading #{using.to_s}: #{index}/#{len} (#{sprintf('%3.1f%%', (index.to_f / len * 100))})"
      end

      
    end

    sql = sql + vals.join(', ') + " ON CONFLICT (#{conflict_keys.join(', ')}) DO NOTHING"
    # ap sql

    puts "> Persisting data..."
    ActiveRecord::Base.connection.execute(sql)
    puts "> Done loading #{using.to_s}: #{using.count} rows in table"
  end

  def time_to_numeric s
    h, m, s = s.split(/\:/)
    return (h.to_i * 3600 + m.to_i * 60 + s.to_i) % 86400
  end
end

class String
  def split_comma_unquote
    return self.strip.split(/\,/).map{ |x| x.gsub(/\"/, '') }
  end
end
