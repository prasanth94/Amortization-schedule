include CreateAmortizationScheduleWithDifferentFirstPayment
include CreateAmortizationScheduleWithEqualPayments

class LoansController < ApplicationController
	def new
		@loan = Loan.new
	end

	def generate_amortization_schedule
		@loan = Loan.new(loan_params)
		if @loan.save
			if @loan.amortization_type == "First month different payment"
			  @amortization_schedule = create_amortization_schedule_with_different_first_payment(@loan)
			else
				@amortization_schedule = create_amortization_schedule_with_equal_payments(@loan)
			end
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

end