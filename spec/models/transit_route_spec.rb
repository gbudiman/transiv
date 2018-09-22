require 'rails_helper'

RSpec.describe TransitRoute, type: :model do
  context 'LA Metro Rail' do
    it 'should list all routes correctly' do
      expect(TransitRoute.get(:all, agency: 'LACMTA_Rail').length).to be > 0
    end

    it 'should list one specific route correctly' do
      expect(TransitRoute.get('801').length).to be > 0
    end

    it 'should list multiple routes correctly' do
      expect(TransitRoute.get(['801', '806']).length).to be > 0
    end
  end
end
