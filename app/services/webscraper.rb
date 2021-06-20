require "open-uri"
require "nokogiri"
require_relative "property"

class WebScraper
  def initialize(@property)
    # Get input parameter for webscraping
    @flattype = get_flattype
    @floornum = @property.floor
    @unitnum = @property.unit
    @areasqm = @property.area
    @postalcode = @property.address
  end

  def get_property_value
    # Get property value from UrbanZoom
    requesturl = "https://www.urbanzoom.com/api/v1/ml/new_valuation?postal_code=#{@postalcode}&floor_number=#{@floornum}&unit_number=#{@unitnum}&area_in_sqm=#{@areasqm}&housing_type=HDB&flat_type=#{@flattype}"
    response = HTTParty.get(requesturl).parsed_response
    response["valuation"].to_i
  end

  def get_lease_remaining
    # Compute lease remaining using completion year from UrbanZoom
    url = "https://www.urbanzoom.com/house-preview?flatType=#{@flattype}&floorNum=#{@floornum}&unitNum=#{@unitnum}&areaInSqm=#{@areasqm}&ref=home-search&housingType=public&postalCode=#{@postalcode}"
    doc = Nokogiri::XML(open(url).read, nil, "utf-8")
    @year_completed = doc.at_css(".project_details__list").children.children.children[-2].text.to_i
    lease_computation
  end

  private

  def get_flattype
    firstword = @property.flat_type.first
    firstword.to_i.to_s == firstword ? "#{firstword}%20ROOM" : @property.flat_type.upcase
  end

  def lease_computation
    lease = 99 - (Date.current.year - @year_completed)
  end
end