class LiveFeed
  def initialize base_uri:
    @base_uri = base_uri
  end

  def get agency:, stop_id:
    uri = URI("#{@base_uri}/agencies/#{agency}/stops/#{stop_id}/predictions/")
    res = Net::HTTP.get_response(uri)

    blocks = {}
    prediction = nil

    JSON.parse(res.body)['items'].each do |prediction|
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
  end
end

