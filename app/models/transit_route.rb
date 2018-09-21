class TransitRoute < ApplicationRecord
  has_many :transit_trips, dependent: :destroy
  
  belongs_to :transit_agency
  validates :transit_agency, presence: true

  def self.get _ids, agency: nil
    q = TransitRoute.joins(:transit_agency)

    if _ids == :all
    else
      ids = _ids.is_a?(Array) ? _ids : [_ids]
      q = q.where(id: ids)
    end

    if agency
      q = q.where('transit_agencies.id' => agency)
    end

    ap q.select(:id, :handle, 
                'transit_agencies.id AS agency_id', 
                'transit_agencies.handle AS agency_handle')
  end
end
