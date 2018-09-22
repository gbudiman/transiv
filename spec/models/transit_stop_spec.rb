require 'rails_helper'

RSpec.describe TransitStop, type: :model do
  before :each do
    @lat = 33.768072
    @long = -118.192799
  end

  context 'proximity' do
    it 'should list in ascending distance' do
      TransitStop.within(@lat, @long).each do |r|
        ap r
      end
    end
  end
end
