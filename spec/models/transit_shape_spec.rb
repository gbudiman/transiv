require 'rails_helper'

RSpec.describe TransitShape, type: :model do
  before :each do
    @t = Time.parse('2018-09-21 19:00:00 -0700')
  end

  context 'listing' do
    it 'should be retrieved correctly' do
      q = TransitRoute.routes_of('802').get_aggregate_paths(at: @t)

      expect(q.length).to be > 0
    end
  end
end
