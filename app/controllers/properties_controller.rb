require "open-uri"
require "nokogiri"

class PropertiesController < ApplicationController

  def index
    @property = Property.new
    @my_property = Property.where(user: current_user)
    @end_year = Date.today.year
    @start_year = Date.today.year - 50
  end

  def create
    @property = Property.new(property_params)
    @property.user = current_user
    # @property.property_value = WebScraper.new(@property).get_property_value
    # @property.lease_remaining = WebScraper.new(@property).get_lease_remaining
    # raise

    # Get input parameter for webscraping
    flattype = get_flattype
    floornum = @property.floor
    unitnum = @property.unit
    areasqm = @property.area
    postalcode = @property.address

    # Get property value from UrbanZoom
    requesturl = "https://www.urbanzoom.com/api/v1/ml/new_valuation?postal_code=#{postalcode}&floor_number=#{floornum}&unit_number=#{unitnum}&area_in_sqm=#{areasqm}&housing_type=HDB&flat_type=#{flattype}"
    response = HTTParty.get(requesturl).parsed_response
    @property.property_value = response["valuation"].to_i

    # Compute lease remaining using completion year from UrbanZoom
    url = "https://www.urbanzoom.com/house-preview?flatType=#{flattype}&floorNum=#{floornum}&unitNum=#{unitnum}&areaInSqm=#{areasqm}&ref=home-search&housingType=public&postalCode=#{postalcode}"
    doc = Nokogiri::XML(open(url).read, nil, "utf-8")
    @year_completed = doc.at_css(".project_details__list").children.children.children[-2].text.to_i
    @property.lease_remaining = lease_computation

    # browser = Watir::Browser.new :chrome, headless: true
    # browser.goto(url)
    # js_doc = browser.element(css: ".zoom-value-prediction").wait_until(&:present?)
    # value = js_doc.inner_html
    # browser.close
    if @property.save
      redirect_to properties_path
    end
  end

  def update
  end

  private

  def property_params
    params.require(:property).permit(:address, :floor, :unit, :property_growth_rate, :property_value, :flat_type, :area, :loan_tenure_years, :loan_interest_annual, :start_ownership_year, :original_loan_amount)
  end

  def get_flattype
    firstword = @property.flat_type.first
    firstword.to_i.to_s == firstword ? "#{firstword}%20ROOM" : @property.flat_type.upcase
  end

  def lease_computation
    lease = 99 - (Date.current.year - @year_completed)
  end
end
