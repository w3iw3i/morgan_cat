require "open-uri"
require "nokogiri"
# require_relative "../controllers/properties_controller.rb"

class WebScraper
  def initialize(flattype, floor, unit, area, postalcode)
    @flattype = flattype
    @floornum = floor
    @unitnum = unit
    @areasqm = area
    @postalcode = postalcode
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
    # @year_completed = Date.current.year if @year_completed.to_s.length != 4
    lease_computation
  end

  def get_display_address
    addressurl = "https://www.urbanzoom.com/api/v1/location/search?locale=en&housing_type=hdb&search_string=#{@postalcode}"
    response = HTTParty.get(addressurl).parsed_response["data"][0]
    response["display_address"].split(",")[0] + ", SINGAPORE #{@postalcode}"
  end

  private

  def lease_computation
    lease = 99 - (Date.current.year - @year_completed)
  end
end