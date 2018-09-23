require 'rails_helper'

RSpec.describe TransitShape, type: :model do
  before :each do
    @t = Time.parse('2018-09-21 19:00:00 -0700')
  end

  context 'listing' do
    it 'should be retrieved correctly' do
      ap TransitRoute.paths_of('802', at: @t)
    end
  end
end
