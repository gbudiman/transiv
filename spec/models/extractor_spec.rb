require 'rails_helper'

RSpec.describe Extractor, type: :model do

  before :each do
    @e = Extractor.new('gtfs_rail-master')
    @e.execute!
  end

  context 'execution' do
    it 'should' do
      @e.accountability
    end
  end
end
