require 'rails_helper'

RSpec.describe Extractor, type: :model do

  before :each do
    Extractor.new 'gtfs_rail-master'
    Extractor.new 'gtfs_rail-master'
  end

  context 'execution' do
    it 'should' do
    end
  end
end
