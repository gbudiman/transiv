require 'rails_helper'

RSpec.describe TransitRoute, type: :model do
  context 'LA Metro Rail' do
    it 'should list all routes correctly' do
      q = TransitRoute.all_routes_of_gtfs_id('LACMTA_Rail')
      expect(q.pluck('transit_routes.gtfs_id')).to contain_exactly('801', '802', '803', '804', '805', '806')
    end

    it 'should list one specific route correctly' do
      q = TransitRoute.routes_of_gtfs_id(801)
      expect(q.pluck('transit_routes.gtfs_id')).to contain_exactly('801')
    end

    it 'should list multiple routes correctly' do
      q = TransitRoute.routes_of_gtfs_id(801, 806).restrict_agency_gtfs_id('LACMTA_Rail')
      expect(q.pluck('transit_routes.gtfs_id')).to contain_exactly('801', '806')
    end
  end
end
