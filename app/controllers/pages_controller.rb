class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :projection ]

  def home
    @user = User.new
    @end_year = Date.today.year
    @start_year = @end_year - 100
  end

  def projection
    projection_arrays
    projection_constants

    # Set up chart axes
    @user = User.new(user_params)
    @user.dob = year_to_dob
    @current_year = Date.current.year
    @current_age = @current_year - year_of_birth
    @monthly_savings = monthly_income - monthly_expenses
    @year = @current_year
    @period = @retirement_age - @current_age

    # For user who have signed in
    if user_signed_in?
      # Account for asset_allocation
      @stocks = Asset.where(user_id: current_user.id, asset_type: "stocks").first
      @bonds = Asset.where(user_id: current_user.id, asset_type: "bonds").first
      @cpfo = Asset.where(user_id: current_user.id, asset_type: "cpfo").first
      @cpfs = Asset.where(user_id: current_user.id, asset_type: "cpfs").first
      @cpfm = Asset.where(user_id: current_user.id, asset_type: "cpfm").first

      # Find cash allocation
      @cash_allocation = 100 - Asset.where(user_id: current_user.id).sum(:asset_allocation)

      # Create asset_projections
      projection_machine(@period, @year, (@rate-@inflation), @value, @cash_allocation * 0.01 * @monthly_savings, @projected_amt)
      projection_machine(@period, @year, (@stocks.growth_rate-@inflation), @value, @stocks.asset_allocation * 0.01 * @monthly_savings, @stocks_projection)
      projection_machine(@period, @year, (@bonds.growth_rate-@inflation), @value, @bonds.asset_allocation * 0.01 * @monthly_savings, @bonds_projection)
      projection_machine(@period, @year, (@cpfo.growth_rate-@inflation), @value, @cpfo.asset_allocation * 0.01 * @monthly_savings, @cpfo_projection)
      projection_machine(@period, @year, (@cpfs.growth_rate-@inflation), @value, @cpfs.asset_allocation * 0.01 * @monthly_savings, @cpfs_projection)
      projection_machine(@period, @year, (@cpfm.growth_rate-@inflation), @value, @cpfm.asset_allocation * 0.01 * @monthly_savings, @cpfm_projection)
    else
      # For new user / user who do not sign in
      # Create cash_projections
      @cash_allocation = 100
      projection_machine(@period, @year, (@rate-@inflation), @value, @cash_allocation * 0.01 * @monthly_savings, @projected_amt)
    end
  end

  def projection_constants
    @rate = 1.5
    @retirement_age = 65
    @value = 0
    @inflation = 1.5
  end

  def projection_arrays
    # cash projected amount
    @projected_amt = []
    # assets projected amount
    @stocks_projection = []
    @bonds_projection = []
    @cpfo_projection = []
    @cpfs_projection = []
    @cpfm_projection = []
    @total_projection = []
  end

  def projection_machine(period, year, inflation_adj_ror, value, monthly_contribution, asset_array)
    period.times do
      year += 1
      value = compound(value, inflation_adj_ror, monthly_contribution).round
      asset_array.append([year.to_s, value])
      #total_projection[year] += value
    end
  end

  private

  def user_params
    params.require(:user).permit(:dob, :monthly_income, :monthly_expenses)
  end

  def year_of_birth
    params[:user][:dob].to_i
  end

  def monthly_expenses
    params[:user][:monthly_expenses].to_i
  end

  def monthly_income
    params[:user][:monthly_income].to_i
  end

  def year_to_dob
    Date.new(year_of_birth, 1, 1)
  end

  def compound(present_value, rate, saving)
    future_value = (present_value + saving * 12) * (1 + (rate / 100))
  end

end
