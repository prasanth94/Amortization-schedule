include CreateAmortizationSchedule

class LoansController < ApplicationController
	def new
		@loan = Loan.new
	end

	def generate_amortization_schedule
		@loan = Loan.new(loan_params)
		if @loan.save
			@amortization_schedule = create_amortization_schedule(@loan)
		else
			render :new
		end
	end

	def index
		@loans= Loan.all
	end


  private

  	def loan_params
  	  params.require(:loan).permit(:loan_amount, :term, :interest_rate, :request_date)
 	 end

end