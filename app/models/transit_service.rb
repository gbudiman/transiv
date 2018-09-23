class TransitService < ApplicationRecord
  has_many :transit_trip_calendars, dependent: :destroy

  scope :active, -> (at) {
    active_day(at).active_service(at)
  }
  
  scope :active_day, -> (at) {
    r = [nil, :is_mon, :is_tue, :is_wed, :is_thu, :is_fri, :is_sat, :is_sun]
    where("transit_services.#{r[at.wday]}" => true)
  }

  scope :active_service, -> (at) {
    where('transit_services.start_date <= :x AND transit_services.end_date >= :y', 
      x: at.beginning_of_day,
      y: at.beginning_of_day - 6.hours)
  }
end
