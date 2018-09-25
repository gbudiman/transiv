class LiveFeed
  def initialize base_uri:, agencies: []
    @base_uri = base_uri
    @agencies = agencies
  end

  def build_queue
    @agencies.each do |agency|
      TransitStop
        .joins_agencies
        .merge(TransitAgency.restrict_agency_by_live_feed(agency))
        .reveal_stop_gtfs_id
        .reveal_stop_id
        .distinct.each do |x|
        LiveWorker.perform_async('feed', @base_uri, agency, x.stop_id, x.stop_gtfs_id)
      end
    end
  end

  def self.get base_uri:, agency:, stop_id:, stop_gtfs_id:
    path = "#{base_uri}/agencies/#{agency}/stops/#{stop_gtfs_id}/predictions/"
    uri = URI(path)
    res = Net::HTTP.get_response(uri)

    blocks = {}
    prediction = nil

    items = JSON.parse(res.body)['items']

    if items
      items.each do |prediction|
        blocks[prediction['block_id']] ||= []
        blocks[prediction['block_id']].push(prediction['seconds'])
      end

      blocks.each do |k, v|
        trip = TransitTrip.find_by(block: k)
        prediction = TransitPrediction.find_or_initialize_by(
                       transit_trip_id: trip.id,
                       transit_stop_id: stop_id)

        prediction.predictions = v
        prediction.save!
      end

      puts "Recorded stop ID #{stop_id}"
      
    end

    return prediction
  end
end

