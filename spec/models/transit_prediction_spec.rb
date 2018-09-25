require 'rails_helper'

RSpec.describe TransitPrediction, type: :model do
  before :each do
    @lf = LiveFeed.new base_uri: 'http://api.metro.net'
  end

  it 'should load predictions data correctly' do
    prediction = @lf.get(agency: 'lametro', stop_id: 5153)
    ap prediction
  end
end
