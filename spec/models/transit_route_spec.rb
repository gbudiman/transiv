require 'rails_helper'

RSpec.describe TransitRoute, type: :model do
  context 'LA Metro Rail' do
    it 'should list all routes correctly' do
      TransitRoute.get :all, agency: 'LACMTA_Rail'
    end

    it 'should list one specific route correctly' do
      TransitRoute.get '801'
    end

    it 'should list multiple routes correctly' do
      TransitRoute.get ['801', '806']
    end
  end
end
