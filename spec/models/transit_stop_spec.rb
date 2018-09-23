require 'rails_helper'

RSpec.describe TransitStop, type: :model do
  before :each do
    @lat = 34.048472
    @lng = -118.258645
  end

  context 'proximity' do
    it 'should list in ascending distance' do
      #ap TransitStop.within(lat: @lat, lng: @lng, distance: 1000).sort_by_route_departure.reveal_route
      t = 5.days.ago
      ap t.localtime
      ap TransitStop.within(lat: @lat, lng: @lng, distance: 200).reveal_route.sort_by_route_name.distinct

    end
  end
end
