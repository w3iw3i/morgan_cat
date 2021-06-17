class PropertiesController < ApplicationController

  def index
    @property = Property.new
    @my_property = Property.where(user: current_user)
  end

  def create
    @property = Property.new(property_params)
    @property.user = current_user
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

end
