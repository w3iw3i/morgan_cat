class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :projection ]

  def home
    @user = User.new
    @end_year = Date.today.year
    @start_year = @end_year - 100
  end

  def projection
    @user = User.new(user_params)
    @user.dob = year_to_dob
    @current_year = Date.current.year
    @current_age = @current_year - year_of_birth
    @monthly_savings = monthly_income - monthly_expenses
    @rate = 1.5
    @retirement_age = 65
    @period = 65 - @current_age
    @projected_amt = []
    @year = @current_year
    @value = 0
    @inflation = 1.5
    @period.times do 
      @year += 1
      @interest = @rate - @inflation
      @value = compound(@value, @rate, @monthly_savings).round
      @projected_amt.append([@year.to_s, @value])
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
