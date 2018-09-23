require 'rails_helper'

RSpec.describe TransitRoute, type: :model do
  context 'LA Metro Rail' do
    it 'should list all routes correctly' do
      q = TransitRoute.routes_of(:all, agency_id: 'LACMTA_Rail')
      expect(q.ids).to contain_exactly('801', '802', '803', '804', '805', '806')
    end

    it 'should list one specific route correctly' do
      q = TransitRoute.routes_of('801')
      expect(q.ids).to contain_exactly('801')
    end

    it 'should list multiple routes correctly' do
      q = TransitRoute.routes_of(['801', '806'])
      expect(q.ids).to contain_exactly('801', '806')
    end
  end
end
