require 'rails_helper'
require 'create_amortization_schedule_with_different_first_payment'

RSpec.describe CreateAmortizationScheduleWithDifferentFirstPayment do

	describe "CreateAmortizationScheduleWithDifferentFirstPayment" do

		let(:dummy_class) { Class.new }
		before do
			dummy_class.extend(CreateAmortizationScheduleWithDifferentFirstPayment)
		end

		it "returns the amortization schedule for the loan" do
			loan = build(:loan, loan_amount: 10000, term: 24, interest_rate: 15, request_date: Date.new(2012,05,10))
			amortization_schedule = dummy_class.create_amortization_schedule_with_different_first_payment(loan)

			expect(amortization_schedule[0][:principal_component].round(2)).to be_equal 359.87
			expect(amortization_schedule[0][:beginning_balance].round(2)).to be_equal 10000.00
			expect(amortization_schedule[0][:ending_balance].round(2)).to be_equal 9640.13
			expect(amortization_schedule[0][:interest_component].round(2)).to be_equal 87.50
			expect(amortization_schedule[0][:monthly_payment].round(2)).to be_equal 447.37
			expect(amortization_schedule[0][:due_date]).to eq Date.new(2012,06,1)

			expect(amortization_schedule[11][:principal_component].round(2)).to be_equal 412.56
			expect(amortization_schedule[11][:beginning_balance].round(2)).to be_equal 5784.55
			expect(amortization_schedule[11][:ending_balance].round(2)).to be_equal 5371.99
			expect(amortization_schedule[11][:interest_component].round(2)).to be_equal 72.31
			expect(amortization_schedule[11][:monthly_payment].round(2)).to be_equal 484.87
			expect(amortization_schedule[11][:due_date]).to eq Date.new(2013,05,1)

			expect(amortization_schedule[23][:principal_component].round(2)).to be_equal 478.88
			expect(amortization_schedule[23][:beginning_balance].round(2)).to be_equal 478.88
			expect(amortization_schedule[23][:ending_balance].round(2)).to be_equal 0.00
			expect(amortization_schedule[23][:interest_component].round(2)).to be_equal 5.99
			expect(amortization_schedule[23][:monthly_payment].round(2)).to be_equal 484.87
			expect(amortization_schedule[23][:due_date]).to eq Date.new(2014,05,1)

		end
	end
end	