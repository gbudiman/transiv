class Extractor
  def initialize bundle
    @bundle = bundle

    extract_agency
    extract_routes
  end

  def extract_agency
    get_iterator('agency.txt').each do |l|
      ap l
    end
  end

  def extract_routes
    get_iterator('routes.txt').each do |l|
      ap l
    end 
  end

private
  def get_iterator file
    return IO.readlines(Rails.root.join('db', 'raw', @bundle, file)).drop(1)
  end
end
