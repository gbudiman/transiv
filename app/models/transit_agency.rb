class TransitAgency < ApplicationRecord
  has_many :transit_routes, dependent: :destroy

  scope :augment_live_feeds, -> {
    TransitAgency.all.each do |agency|
      agency.live_feed = case agency.gtfs_id
      when 'LACMTA_Rail' then 'lametro-rail'
      when 'LACMTA' then 'lametro'
      end

      agency.save!
    end
  }

  scope :restrict_agency_by_gtfs_id, -> (gtfs_id) {
    where(gtfs_id: gtfs_id)
  }

  scope :restrict_agency_by_live_feed, -> (live_feed) {
    where(live_feed: live_feed)
  }
end
