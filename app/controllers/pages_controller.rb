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
  end

  private

  def user_params
    params.require(:user).permit(:dob, :monthly_income, :monthly_expenses)
  end

  def year_to_dob
    Date.new(params[:user][:dob].to_i, 1, 1)
  end
end
