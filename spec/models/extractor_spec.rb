require 'rails_helper'

RSpec.describe Extractor, type: :model do
  context 're-entrancy' do
    it 'should reflect database content correctly' do
      e = Extractor.new('gtfs_rail-master')
      e.execute!
      Extractor.new('gtfs_rail-master').execute!
      expect(e.accountability).to eq true
    end
  end

  context 'bus data' do
    it 'should be handled correctly' do
      Extractor.new('gtfs_bus-master').execute!
    end
  end
end
