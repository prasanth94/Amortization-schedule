require 'rails_helper'
require 'create_amortization_schedule_with_equal_payments'

RSpec.describe CreateAmortizationScheduleWithEqualPayments do

	describe "CreateAmortizationScheduleWithEqualPayments" do

		let(:dummy_class) { Class.new }
		before do
			dummy_class.extend(CreateAmortizationScheduleWithEqualPayments)
		end

		it "returns the amortization schedule for the loan" do
			loan = build(:loan, loan_amount: 10000, term: 12, interest_rate: 10, request_date: Date.new(2017,05,15))
			amortization_schedule = dummy_class.create_amortization_schedule_with_equal_payments(loan)

			expect(amortization_schedule[0][:principal_component].round(2)).to be_equal 829.37
			expect(amortization_schedule[0][:beginning_balance].round(2)).to be_equal 10000.00
			expect(amortization_schedule[0][:ending_balance].round(2)).to be_equal 9170.63
			expect(amortization_schedule[0][:interest_component].round(2)).to be_equal 46.58
			expect(amortization_schedule[0][:monthly_payment].round(2)).to be_equal 875.95
			expect(amortization_schedule[0][:due_date]).to eq Date.new(2017,06,1)

			expect(amortization_schedule[11][:principal_component].round(2)).to be_equal 826.51
			expect(amortization_schedule[11][:beginning_balance].round(2)).to be_equal 5932.32
			expect(amortization_schedule[11][:ending_balance].round(2)).to be_equal 5105.81
			expect(amortization_schedule[11][:interest_component].round(2)).to be_equal 49.44
			expect(amortization_schedule[11][:monthly_payment].round(2)).to be_equal 875.95
			expect(amortization_schedule[11][:due_date]).to eq Date.new(2017,11,1)

			expect(amortization_schedule[23][:principal_component].round(2)).to be_equal 868.77
			expect(amortization_schedule[23][:beginning_balance].round(2)).to be_equal 868.77
			expect(amortization_schedule[23][:ending_balance].round(2)).to be_equal 0.00
			expect(amortization_schedule[23][:interest_component].round(2)).to be_equal 7.24
			expect(amortization_schedule[23][:monthly_payment].round(2)).to be_equal 876.01
			expect(amortization_schedule[23][:due_date]).to eq Date.new(2018,05,1)

		end
	end
end