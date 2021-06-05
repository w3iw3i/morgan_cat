require 'pry-byebug'

class ExpensesController < ApplicationController
  def index
    @expenses = Expense.all
    @user = current_user
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    years_to_compound =  @expense.year_int - Time.now.year
    inflation = 0.02
    @expense.inflated_amt =  @expense.amount*(1+inflation)**(years_to_compound)
    @expense.user = current_user
    @expense.save

    redirect_to user_expenses_path(current_user)
  end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy

    redirect_to user_expenses_path(current_user)
  end

private

  def expense_params
    params.require("/users/#{current_user.id}/expenses").permit(:expense_type, :amount, :year_int)
  end
end

