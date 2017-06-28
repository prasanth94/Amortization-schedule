include CreateAmortizationScheduleWithDifferentFirstPayment
include CreateAmortizationScheduleWithEqualPayments

class LoansController < ApplicationController
  def new
    @loan = Loan.new
  end

  def create
    @loan = Loan.new(loan_params)
    if @loan.save
      redirect_to generate_amortization_schedule_loan_path(@loan)
    else
      render :new
    end
  end

  def generate_amortization_schedule
    @loan = Loan.find(params[:id])
    @amortization_schedule = find_amortization_schedule
  end

  def index
    @loans = Loan.all
  end

  private

  def loan_params
    params.require(:loan).permit(:loan_amount, :term, :interest_rate, :request_date, :amortization_type)
  end

  def find_amortization_schedule
    if @loan.amortization_type == 'First month different payment'
      create_amortization_schedule_with_different_first_payment(principal_amount: @loan.loan_amount,
                           interest_rate: @loan.interest_rate, term: @loan.term, request_date: @loan.request_date)
    else
      create_amortization_schedule_with_equal_payments(principal_amount: @loan.loan_amount,
                           interest_rate: @loan.interest_rate, term: @loan.term, request_date: @loan.request_date)
    end
  end
end
