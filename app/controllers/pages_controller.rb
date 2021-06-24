class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :projection ]

  def home
    @user = get_user_home
    @end_year = Date.today.year - 20
    @start_year = Date.today.year - 45
  end

  def projection
    @user = get_user_projection
    projection_constants
    projection_arrays
    projection_calcs
    user_assets

    if user_signed_in?

      # Create asset_projections
      projection_machine(@period, @year, (@rate-@inflation), (@cash.amount + @value), @cash.asset_allocation * 0.01 * @monthly_savings, @projected_amt, "Cash")
      projection_machine(@period, @year, (@stocks.growth_rate-@inflation), (@stocks.amount + @value), @stocks.asset_allocation * 0.01 * @monthly_savings, @stocks_projection)
      projection_machine(@period, @year, (@bonds.growth_rate-@inflation), (@bonds.amount + @value), @bonds.asset_allocation * 0.01 * @monthly_savings, @bonds_projection)
      projection_machine(@period, @year, (@cpfo.growth_rate-@inflation), (@cpfo.amount + @value), @cpfo.asset_allocation * 0.01 * @monthly_savings, @cpfo_projection)
      projection_machine(@period, @year, (@cpfs.growth_rate-@inflation), (@cpfs.amount + @value), @cpfs.asset_allocation * 0.01 * @monthly_savings, @cpfs_projection)
      projection_machine(@period, @year, (@cpfm.growth_rate-@inflation), (@cpfm.amount + @value), @cpfm.asset_allocation * 0.01 * @monthly_savings, @cpfm_projection)

      # Find the list of properties belonging to the user
      prop_list = Property.where(user_id: current_user.id)
      prop_list.each_with_index do |property, index|

        @property_data[index] = []

        # Factor in values for each property
        @loan_amount = property.original_loan_amount
        @loan_interest_annual = property.loan_interest_annual
        @loan_tenure_years = property.loan_tenure_years
        @start_ownership_year = property.start_ownership_year

        projection_machine(@period, @year, (2.5-@inflation), @prop_current_value, 0, @property_data[index])

        # Account for Property Lease Decay
        @property_data[index] = lease_decay(@property_data[index], 80, @period)

        # Account for home loan / home equity
        @loan_outstanding_cumulative = loan_outstanding_by_year(@loan_amount, @loan_interest_annual, @loan_tenure_years, @start_ownership_year)
        @property_data[index] = home_equity(@property_data[index], @loan_outstanding_cumulative)
      end

    else
      # For new user / user who do not sign in
      # Create cash_projections
      @cash_allocation = 100
      projection_machine(@period, @year, (@rate-@inflation), @value, @cash_allocation * 0.01 * @monthly_savings, @projected_amt)
    end

    # @user_cash = get_user_asset("Cash") || Asset.new(amount: 0, asset_allocation: 0, growth_rate: 0)
  end

  def scenario_planning
    if user_signed_in?
      @user = get_user_projection
      projection_constants
      projection_arrays
      projection_calcs
      scenarios
    end
  end

  def property
    @user = get_user_projection
    projection_constants
    projection_arrays
    projection_calcs

    projection_machine(@period, @year, (2.5-@inflation), @prop_current_value, 0, @property_projection)
    @property_growth = @property_projection.deep_dup
    @property_growth_decay = lease_decay(@property_projection, 80, @period).deep_dup

    # temp values
    @loan_amount = 315000
    @loan_interest_annual = 0.050
    @loan_tenure_years = 20
    @start_ownership_year = 2020

    @loan_outstanding_cumulative = loan_outstanding_by_year(@loan_amount, @loan_interest_annual, @loan_tenure_years, @start_ownership_year)
    @home_equity =  home_equity(@property_projection, @loan_outstanding_cumulative)
  end

  private

  def scenario_engine(scenario_array, cash_allocation, stocks_allocation, bonds_allocation)
    @scenario_hash.each do |key, value|
      @cash_scenario_proj = projection_machine(@period, @year, value[0], (@cash.amount + @value), cash_allocation * 0.01 * @monthly_savings, @projected_amt, "Cash")
      @stocks_scenario_proj = projection_machine(@period, @year, (value[1]-@inflation), (@stocks.amount + @value), stocks_allocation * 0.01 * @monthly_savings, @stocks_projection)
      @bonds_scenario_proj = projection_machine(@period, @year, (value[2]-@inflation), (@bonds.amount + @value), bonds_allocation * 0.01 * @monthly_savings, @bonds_projection)
      @total_scenario_proj = @cash_scenario_proj+@stocks_scenario_proj+@bonds_scenario_proj
      scenario_array << @total_scenario_proj

      if key == :average
        @combined = @projected_amt + @stocks_projection + @bonds_projection
        @scenario_chartline << @combined.group_by { |row| row[0] }.map do |_, collection|
          collection.reduce do |result, row|
            result[1] += row[1]
            result
          end
        end
      end
    @projected_amt = []
    @stocks_projection = []
    @bonds_projection = []
    end
  end

  def projection_machine(period, year, inflation_adj_ror, value, monthly_contribution, asset_array, asset_type="Noncash")
    expenses = Expense.where(user_id: current_user.id).select([:year_int, :inflated_amt]) if user_signed_in?
    period.times do
      value = compound(value, inflation_adj_ror, monthly_contribution).round
      if asset_type == "Cash"
        expenses.to_a.each do |expense|
          if expense[:year_int] == year
            value -= expense[:inflated_amt]
          end
        end
      end
      asset_array.append([year.to_s, value])
      year += 1
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
    @retirement_age = user_signed_in? ? @user.target_retirement_age : 65
    @value = 0
    @inflation = 1.5
    @prop_current_value = 350000

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
    @property_data = []
    @scenario_chartline = []
    @property_projection = []
    @principal_paid_annual = []
    @loan_outstanding_cumulative = []
  end

  def projection_calcs
    @current_year = Date.current.year
    @current_age = @current_year - @user.dob.year.to_i
    @monthly_savings = @user.monthly_income.to_i - @user.monthly_expenses.to_i
    @year = @current_year
    @period = @retirement_age - @current_age
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

  def get_user_asset(asset)
    Asset.where(user_id: current_user.id, asset_type: asset).first
  end

  def default_asset(asset)
    Asset.new(amount: 0, asset_allocation: 0, growth_rate: 0, asset_type: asset)
  end

  def user_assets
    # Pull the relevant asset information for the user
    if user_signed_in?
      @cash = get_user_asset("Cash") || default_asset("Cash")
      @stocks = get_user_asset("Stock") || default_asset("Stock")
      @bonds = get_user_asset("Bond") || default_asset("Bond")
      @cpfo = get_user_asset("CPF-O") || default_asset("CPF-O")
      @cpfs = get_user_asset("CPF-S") || default_asset("CPF-S")
      @cpfm = get_user_asset("CPF-M") || default_asset("CPF-M")
    else
      @cash = default_asset("Cash")
      @stocks = default_asset("Stock")
      @bonds = default_asset("Bond")
      @cpfo = default_asset("CPF-O")
      @cpfs = default_asset("CPF-S")
      @cpfm = default_asset("CPF-M")
    end
    # Find cash allocation
    # @cash_allocation = 100 - Asset.where(user_id: current_user.id).sum(:asset_allocation)
  end

  def asset_index
    @asset = Asset.new
    @my_asset = Asset.where(user: current_user)
  end

def asset_params
    params.require(:asset).permit(:asset_type, :amount, :growth_rate, :asset_allocation)
  end

  def lease_decay(property_projection, lease_remaining, period)
    Leasehold_table
    #search for remaining lease % value of freehold
    @counter = lease_remaining
    @base_percentile = Leasehold_table[@counter][1]

    property_projection.each do |element|
      element[1] = element[1] * (Leasehold_table[@counter-1][1] / @base_percentile)
      @counter -= 1
    end
    property_projection
  end

  def loan_outstanding_by_year(loan_amount, interest_rate, loan_tenure, start_year)
    @pmt = Exonio.pmt(interest_rate / 12, 12 * loan_tenure, loan_amount)
    @payment_month = 1
    @start_year = start_year
    @principal_paid_cumulative = 0

    loan_tenure.times do
      @principal_paid_annual << [@year, 0]
      12.times do
        @principal = @pmt - Exonio.ipmt(interest_rate / 12, @payment_month, 12 * loan_tenure, loan_amount)
        @principal_paid_annual.last[1] += @principal
        @payment_month += 1
      end
      @principal_paid_cumulative += @principal_paid_annual.last[1]
      @loan_outstanding_cumulative << [@start_year, loan_amount + @principal_paid_cumulative]
      @start_year += 1
    end
    @loan_outstanding_cumulative
  end

  def home_equity(property_projection, loan_outstanding_cumulative)
    property_projection.each do |property_value|
      loan_outstanding_cumulative.each do |loan_outstanding|
        if property_value[0].to_i == loan_outstanding[0]
          property_value[1] -= [loan_outstanding[1],0].max
        end
      end
    end
    property_projection
  end



  Leasehold_table = [
    [0,0],
    [1,3.8],
    [2, 7.5],
    [3, 10.9],
    [4, 14.1],
    [5, 17.1],
    [6, 19.9],
    [7, 22.7],
    [8, 25.2],
    [9, 27.7],
    [10, 30.0],
    [11, 32.2],
    [12, 34.3],
    [13, 36.3],
    [14, 38.2],
    [15, 40.0],
    [16, 41.8],
    [17, 43.4],
    [18, 45.0],
    [19, 46.6],
    [20, 48.0],
    [21, 49.5],
    [22, 50.8],
    [23, 52.1],
    [24, 53.4],
    [25, 54.6],
    [26, 55.8],
    [27, 56.9],
    [28, 58.0],
    [29, 59.0],
    [30, 60.0],
    [31, 61.0],
    [32, 61.9],
    [33, 62.8],
    [34, 63.7],
    [35, 64.6],
    [36, 65.4],
    [37, 66.2],
    [38, 67.0],
    [39, 67.7],
    [40, 68.5],
    [41, 69.2],
    [42, 69.8],
    [43, 70.5],
    [44, 71.2],
    [45, 71.8],
    [46, 72.4],
    [47, 73.0],
    [48, 73.6],
    [49, 74.1],
    [50, 74.7],
    [51, 75.2],
    [52, 75.7],
    [53, 76.2],
    [54, 76.7],
    [55, 77.3],
    [56, 77.9],
    [57, 78.5],
    [58, 79.0],
    [59, 79.5],
    [60, 80.0],
    [61, 80.6],
    [62, 81.2],
    [63, 81.8],
    [64, 82.4],
    [65, 83.0],
    [66, 83.6],
    [67, 84.2],
    [68, 84.5],
    [69, 85.4],
    [70, 86.0],
    [71, 86.5],
    [72, 87.0],
    [73, 87.5],
    [74, 88.0],
    [75, 88.5],
    [76, 89.0],
    [77, 89.5],
    [78, 90.0],
    [79, 90.5],
    [80, 91.0],
    [81, 91.4],
    [82, 91.8],
    [83, 92.2],
    [84, 92.6],
    [85, 92.9],
    [86, 93.3],
    [87, 93.6],
    [88, 94.0],
    [89, 94.3],
    [90, 94.6],
    [91, 94.8],
    [92, 95.0],
    [93, 95.2],
    [94, 95.4],
    [95, 95.7],
    [96, 95.7],
    [97, 95.8],
    [98, 95.9],
    [99, 96.0]
  ]
end

