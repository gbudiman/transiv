require 'rails_helper'

RSpec.describe TransitStop, type: :model do
  before :each do
    @lat = 34.047433
    @long = -118.257361
  end

  context 'proximity' do
    it 'should list in ascending distance' do
      TransitStop.within(@lat, @long, 50).each do |r|
        ap r
      end
    end
  end
end
