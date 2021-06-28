class ExpensesController < ApplicationController
  def index
    @expenses = Expense.all
    @user = current_user
    @expense = Expense.new
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
    if @expense.save
      redirect_to expenses_path
    end
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def update
    @expense = Expense.find(params[:id])
    @expense.update(expense_params)
    if @expense.save
      redirect_to expenses_path
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    redirect_to expenses_path
  end

private

  def expense_params
    params.require(:expense).permit(:expense_type, :amount, :year_int)
  end
end

