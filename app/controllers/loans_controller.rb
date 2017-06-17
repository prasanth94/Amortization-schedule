class LoansController < ApplicationController
	def new
		@loan = Loan.new
	end

	def generate_amortization_schedule
		@loan = Loan.new(loan_params)
		if @loan.save
			@loans = Loan.all
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