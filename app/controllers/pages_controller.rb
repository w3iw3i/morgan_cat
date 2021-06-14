class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :projection ]

  def home
    @user = get_user_home
    @end_year = Date.today.year - 20
    @start_year = Date.today.year - 45
  end

  def projection
    projection_constants
    projection_arrays
    @user = get_user_projection
    @current_year = Date.current.year
    @current_age = @current_year - @user.dob.year.to_i
    @monthly_savings = @user.monthly_income.to_i - @user.monthly_expenses.to_i
    @year = @current_year
    @period = @retirement_age - @current_age

    if user_signed_in? && Asset.exists?(user_id: @user.id)
      user_assets

      # Create asset_projections
      projection_machine(@period, @year, (@rate-@inflation), (@cash.amount + @value), @cash.asset_allocation * 0.01 * @monthly_savings, @projected_amt, "cash")
      projection_machine(@period, @year, (@stocks.growth_rate-@inflation), (@stocks.amount + @value), @stocks.asset_allocation * 0.01 * @monthly_savings, @stocks_projection)
      projection_machine(@period, @year, (@bonds.growth_rate-@inflation), (@bonds.amount + @value), @bonds.asset_allocation * 0.01 * @monthly_savings, @bonds_projection)
      projection_machine(@period, @year, (@cpfo.growth_rate-@inflation), (@cpfo.amount + @value), @cpfo.asset_allocation * 0.01 * @monthly_savings, @cpfo_projection)
      projection_machine(@period, @year, (@cpfs.growth_rate-@inflation), (@cpfs.amount + @value), @cpfs.asset_allocation * 0.01 * @monthly_savings, @cpfs_projection)
      projection_machine(@period, @year, (@cpfm.growth_rate-@inflation), (@cpfm.amount + @value), @cpfm.asset_allocation * 0.01 * @monthly_savings, @cpfm_projection)

      scenarios
    else
      # For new user / user who do not sign in
      # Create cash_projections
      @cash_allocation = 100
      projection_machine(@period, @year, (@rate-@inflation), @value, @cash_allocation * 0.01 * @monthly_savings, @projected_amt)
    end
  end

  private

  def scenario_engine(scenario_array, cash_allocation, stocks_allocation, bonds_allocation)
    @scenario_hash.each do |key, value|
      @cash_scenario_proj = projection_machine(@period, @year, value[0], (@cash.amount + @value), cash_allocation * 0.01 * @monthly_savings, @projected_amt, "cash")
      @stocks_scenario_proj = projection_machine(@period, @year, (value[1]-@inflation), (@stocks.amount + @value), stocks_allocation * 0.01 * @monthly_savings, @stocks_projection)
      @bonds_scenario_proj = projection_machine(@period, @year, (value[2]-@inflation), (@bonds.amount + @value), bonds_allocation * 0.01 * @monthly_savings, @bonds_projection)
      @total_scenario_proj = @cash_scenario_proj+@stocks_scenario_proj+@bonds_scenario_proj
      scenario_array << @total_scenario_proj
    end
  end

  def projection_machine(period, year, inflation_adj_ror, value, monthly_contribution, asset_array, asset_type="Noncash")
    expenses = Expense.where(user_id: current_user.id).select([:year_int, :inflated_amt]) if user_signed_in?
    period.times do
      year += 1
      value = compound(value, inflation_adj_ror, monthly_contribution).round
      if asset_type == "cash"
        expenses.to_a.each do |expense|
          if expense[:year_int] == year
            value -= expense[:inflated_amt]
          end
        end
      end
        asset_array.append([year.to_s, value])
    end
    value
  end

  def scenarios
    projection_constants
    user_assets
    @scenario_hash = {
      average: [@rate-@inflation, @stocks_average, @bonds_average],
      top90_percentile: [@rate-@inflation, @stocks_90, @bonds_90],
      bottom10_percentile: [@rate-@inflation, @stocks_10, @bonds_10]
    }
    @baseline_scenario = []
    @stock80_scenario = []
    @stock60_scenario = []

    # User Baseline Scenario
    scenario_engine(@baseline_scenario, @cash.asset_allocation, @stocks.asset_allocation, @bonds.asset_allocation)
    scenario_engine(@stock80_scenario, 10, 80, 10)
    scenario_engine(@stock60_scenario, 10, 60, 30)
  end

  def user_params
    params.require(:user).permit(:dob, :monthly_income, :monthly_expenses)
  end

  def projection_constants
    @rate = 1.5
    @retirement_age = 65
    @value = 0
    @inflation = 1.5

    # stocks
    @stocks_average = 5 + @inflation
    @stocks_sd = 3
    @stocks_90 = @stocks_average + 1.5 * @stocks_sd
    @stocks_10 = @stocks_average - 1.5 * @stocks_sd

    #bonds
    @bonds_average = 2 + @inflation
    @bonds_sd = 0.5
    @bonds_90 = @bonds_average + 1.5 * @bonds_sd
    @bonds_10 = @bonds_average - 1.5 * @bonds_sd
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
  end

  def get_user_home
    user_signed_in? ? current_user : User.new
  end

  def get_user_projection
    if user_signed_in?
      current_user
    else
      user_params = params.require(:user).permit(:dob, :monthly_income, :monthly_expenses)
      user = User.new(user_params)
      user.dob = year_to_dob
      user
    end
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

  def user_assets
    # Pull the relevant asset information for the user
    @cash = Asset.where(user_id: current_user.id, asset_type: "cash").first
    @stocks = Asset.where(user_id: current_user.id, asset_type: "stocks").first
    @bonds = Asset.where(user_id: current_user.id, asset_type: "bonds").first
    @cpfo = Asset.where(user_id: current_user.id, asset_type: "cpfo").first
    @cpfs = Asset.where(user_id: current_user.id, asset_type: "cpfs").first
    @cpfm = Asset.where(user_id: current_user.id, asset_type: "cpfm").first
    # Find cash allocation
    # @cash_allocation = 100 - Asset.where(user_id: current_user.id).sum(:asset_allocation)
  end

end
