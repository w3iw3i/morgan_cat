require "open-uri"
require "nokogiri"

class PropertiesController < ApplicationController

  def index
    @property = Property.new
    @my_property = Property.where(user: current_user)
  end

  def create
    @property = Property.new(property_params)
    @property.user = current_user
    flattype = @property.flat_type.first
    floornum = @property.floor
    unitnum = @property.unit
    areasqm = @property.area
    postalcode = @property.address
    # url = "https://www.urbanzoom.com/house-preview?flatType=#{flattype}%20ROOM&floorNum=#{floornum}&unitNum=#{unitnum}&areaInSqm=#{areasqm}&ref=home-search&housingType=public&postalCode=#{postalcode}"
    url = "https://www.urbanzoom.com/house-preview?areaInSqm=#{areasqm}&flatType=#{flattype}+ROOM&floorNum=#{floornum}&housingType=public&postalCode=#{postalcode}&ref=home-search&unitNum=#{unitnum}"
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto(url)
    js_doc = browser.element(css: ".zoom-value-prediction").wait_until(&:present?)
    value = js_doc.inner_html
    browser.close

    # raise

    html = open(url).read
    doc = Nokogiri::HTML(html, nil, "utf-8")
    property_value = doc.search(".zoom-value-prediction").text
    @completed = doc.search(".project_details__list").text
    raise
    @property.lease_remaining = lease_computation

    if @property.save
      redirect_to properties_path
    end
  end

  def update
  end

  private

  def property_params
    params.require(:property).permit(:address, :floor, :unit, :property_growth_rate, :property_value, :flat_type, :area, :lease_remaining)
  end

  def lease_computation
    lease = 99 - (Date.current.year - @completed)
  end

end
