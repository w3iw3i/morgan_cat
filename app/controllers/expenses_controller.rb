class ExpensesController < ApplicationController
  def index
    @expenses = Expense.all
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.user = current_user
    @expense.save
  end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
  end

  def expense_params
    params.require(:expense).permit(:expense_type, :amount, :user)
  end
end
