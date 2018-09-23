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

  context 'in a specific route' do
    it 'should list all stops' do
      q = TransitRoute.routes_of(['801', '802']).get_aggregate_stops(at: @t)
      expect(q.reveal_stop_info.ids).to include('801', '802')
    end
  end

  # context 'proximity' do
  #   it 'should list in ascending distance' do
  #     w = TransitStop.within(lat: @lat, lng: @lng, at: @t, distance: 200).reveal_route

  #     w.sort_by_route_name.distinct
  #     ap w.sort_by_route_departure.reveal_stop_times.filter_routes(['801', '802'])
  #   end
  # end
end
