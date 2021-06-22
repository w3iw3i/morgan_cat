require "open-uri"
require "nokogiri"
require_relative "../services/web_scraper.rb"

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
    webscraper = WebScraper.new(get_flattype, @property.floor, @property.unit, @property.area, @property.address)
    @property.property_value = webscraper.get_property_value
    @property.lease_remaining = webscraper.get_lease_remaining
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
end
