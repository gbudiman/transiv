require 'rails_helper'

RSpec.describe Extractor, type: :model do

  before :each do
    #Extractor.extract_agency bundle: 'gtfs_rail-master'
    #Extractor.extract_routes bundle: 'gtfs_rail-master'
    @e = Extractor.new 'gtfs_rail-master'
  end

  context 'execution' do
    it 'should' do
    end
  end
end
