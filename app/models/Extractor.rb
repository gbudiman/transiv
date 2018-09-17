class Extractor
  def initialize bundle
    @bundle = bundle
    @h = {}

    extract_agency
    #extract_routes
    #extract_trips
  end

  def extract_agency
    get_iterator('agency.txt').each do |l|
      # id, name = l.split(/\,/)
      # ap id
      # ap name
      @h[:id], @h[:name] = l.split_comma_unquote 
      ap @h
      puts @h[:id]
    end
  end

  def extract_routes
    get_iterator('routes.txt').each do |l|
      ap l
    end 
  end

  def extract_trips
    get_iterator('trips.txt').each do |l|
      ap l
    end
  end

  def extract_shapes
    get_iterator('shapes.txt').each do |l|
      ap l
    end
  end

  def extract_stops
    get_iterator('stops.txt').each do |l|
      ap l
    end
  end

  def extract_stop_times
    get_iterator('stop_times.txt').each do |l|
    end
  end

private
  def get_iterator file
    return IO.readlines(Rails.root.join('db', 'raw', @bundle, file)).drop(1)
  end

  
end

class String
  def split_comma_unquote
    return self.split(/\,/).map{ |x| x.gsub(/\"/, '') }
  end
end
