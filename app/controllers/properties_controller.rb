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
    webscrape_info
    if @property.save
      redirect_to properties_path
    end
  end

  def edit
    @property = Property.find(params[:id])
    @end_year = Date.today.year
    @start_year = Date.today.year - 50
  end

  def update
    @property = Property.find(params[:id])
    @property.update(property_params)
    webscrape_info
    if @property.save
      redirect_to properties_path
    end
  end

  def destroy
    @property = Property.find(params[:id])
    @property.destroy
    redirect_to properties_path
  end

  private

  def property_params
    params.require(:property).permit(:address, :postal_code, :floor, :unit, :property_growth_rate, :property_value, :flat_type, :area, :loan_tenure_years, :loan_interest_annual, :start_ownership_year, :original_loan_amount)
  end

  def get_flattype
    firstword = @property.flat_type.first
    firstword.to_i.to_s == firstword ? "#{firstword}%20ROOM" : @property.flat_type.upcase
  end

  def webscrape_info
    webscraper = WebScraper.new(get_flattype, @property.floor, @property.unit, @property.area, @property.postal_code)
    @property.property_value = webscraper.get_property_value
    @property.lease_remaining = webscraper.get_lease_remaining
    @property.address = webscraper.get_display_address
  end
end
