require 'rails_helper'

RSpec.describe LiveFeed, type: :model do
  it 'should queue jobs correctly' do
    lf = LiveFeed.new base_uri: 'http://api.metro.net', agencies: ['lametro', 'lametro-rail']
    lf.build_queue
  end
end
