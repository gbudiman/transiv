require 'rails_helper'

RSpec.describe TransitStop, type: :model do
  before :each do
    @lat = 33.768072
    @long = -118.192799
  end

  context 'proximity' do
    it 'should list in ascending distance' do
      TransitStop.get_stops(from: [@lat, @long]).each do |r|
        puts r.dist
      end
    end
  end
end
