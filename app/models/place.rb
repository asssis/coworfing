class Place < ActiveRecord::Base
  attr_accessible :address_line1, :address_line2, :city, :country, :desc, :name, :transport, :website, :wifi, :zipcode, :kind, :features, :photos_attributes

  geocoded_by :address 

  # only add at the end
  bitmask :features, as: [:discussion, :music, :smoke]
  symbolize :kind, in: [:private, :public, :business], scopes: true, methods: true

  belongs_to :user

  has_many :place_requests
  has_many :comments
  has_many :photos, :dependent => :destroy
  accepts_nested_attributes_for :photos, :allow_destroy => true, :reject_if => Proc.new { |p| p[:photo].blank? && p[:photo_cache].blank? }
  
  delegate :name, :username, to: :user, allow_nil: true, prefix: true

  validates :name, length: { in: 5..45 }
  validates :desc, length: { in: 5..500 }, presence: true
  validates :address_line1, presence: true
  validates :city, presence: true
  validates :country, presence: true

  after_validation :geocode, if: lambda { |o| o.address_line1_changed? || o.city_changed? || o.country_changed? }

  class << self
    def location(location=[])
      unless location.blank?
        loc = location.is_a?(Array) ? location[0] : location
        geo = Geocoder.search(loc.gsub("-", " "))[0]
        if geo
          box = [
                  geo.geometry["bounds"]["southwest"]["lat"],
                  geo.geometry["bounds"]["southwest"]["lng"], 
                  geo.geometry["bounds"]["northeast"]["lat"],
                  geo.geometry["bounds"]["northeast"]["lng"], 
                ]
          within_bounding_box(box)
        end
      else
        scoped
      end
    end
  end

  def address
    [address_line1, city, country].join(', ')
  end
end
