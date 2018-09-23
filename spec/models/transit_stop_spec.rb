require 'rails_helper'

RSpec.describe TransitStop, type: :model do
  before :each do
    # 7MC
    @lat = 34.048472 
    @lng = -118.258645

    # Union station
    # @lat = 34.056197
    # @lng = -118.234249

    @t = Time.parse('2018-09-21 19:00:00 -0700')
  end

  context 'proximity' do
    it 'should list in ascending distance' do
      ap TransitStop.within(lat: @lat, lng: @lng, at: @t, distance: 200).reveal_route.sort_by_route_name.distinct

    end
  end
end
