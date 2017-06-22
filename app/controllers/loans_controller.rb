include CreateAmortizationScheduleWithDifferentFirstPayment
include CreateAmortizationScheduleWithEqualPayments

class LoansController < ApplicationController
	def new
		@loan = Loan.new
	end

	def generate_amortization_schedule
		@loan = Loan.new(loan_params)

		if @loan.save
			@amortization_schedule = find_amortization_schedule
		else
			render :new
		end
	end

	def index
		@loans= Loan.all
	end


  private

  def loan_params
    params.require(:loan).permit(:loan_amount, :term, :interest_rate, :request_date, :amortization_type)
 	end

 	def find_amortization_schedule
 	 	if @loan.amortization_type == "First month different payment"
			create_amortization_schedule_with_different_first_payment(@loan)
		else
			create_amortization_schedule_with_equal_payments(@loan)
		end
 	end

end