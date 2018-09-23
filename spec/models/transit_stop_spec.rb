require 'rails_helper'

RSpec.describe TransitStop, type: :model do
  before :each do
    # 7MC
    @lat = 34.048472 
    @lng = -118.258645

    # Union station
    # @lat = 34.056197
    # @lng = -118.234249

    @t = Time.parse('2018-09-22 17:00:00 -0700')
    @t_start, @t_end = @t.seconds_since_midnight - 10*60, @t.seconds_since_midnight + 30*60
  end

  context 'in a specific route' do
    it 'should list all stops' do
      q = TransitRoute.routes_of(['801', '802']).get_aggregate_stops(at: @t)
      expect(q.reveal_stop_info.ids).to include('801', '802')
    end
  end

  context 'proximity' do
    it 'should list in ascending distance' do
      q = TransitStop.within(lat: @lat, lng: @lng, at: @t, distance: 200).reveal_route

      expect(q.sort_by_route_name.distinct.pluck('transit_routes.id')).to include('801', '802', '805', '806')
      expect(q.distinct.pluck('transit_routes.shorthand')).to include('910', '20')

      d = q.reveal_stop_times.filter_routes(['801', '802'])
      expect(d.distinct.pluck('transit_routes.id')).to include('801', '802')
      expect(d.distinct.pluck('transit_stop_times.departure')).to all((be >= @t_start).and(be <= @t_end))
    end
  end
end
