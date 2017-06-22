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

			expect(amortization_schedule[0][:principal_component].round(2)).to be_equal 831.32
			expect(amortization_schedule[0][:beginning_balance].round(2)).to be_equal 10000.00
			expect(amortization_schedule[0][:ending_balance].round(2)).to be_equal 9168.68
			expect(amortization_schedule[0][:interest_component].round(2)).to be_equal 44.44
			expect(amortization_schedule[0][:monthly_payment].round(2)).to be_equal 875.77
			expect(amortization_schedule[0][:due_date]).to eq Date.new(2017,06,1)

			expect(amortization_schedule[5][:principal_component].round(2)).to be_equal 826.34
			expect(amortization_schedule[5][:beginning_balance].round(2)).to be_equal 5931.03
			expect(amortization_schedule[5][:ending_balance].round(2)).to be_equal 5104.69
			expect(amortization_schedule[5][:interest_component].round(2)).to be_equal 49.43
			expect(amortization_schedule[5][:monthly_payment].round(2)).to be_equal 875.77
			expect(amortization_schedule[5][:due_date]).to eq Date.new(2017,11,1)

			expect(amortization_schedule[11][:principal_component].round(2)).to be_equal 868.52
			expect(amortization_schedule[11][:beginning_balance].round(2)).to be_equal 868.52
			expect(amortization_schedule[11][:ending_balance].round(2)).to be_equal 0.00
			expect(amortization_schedule[11][:interest_component].round(2)).to be_equal 7.24
			expect(amortization_schedule[11][:monthly_payment].round(2)).to be_equal 875.76
			expect(amortization_schedule[11][:due_date]).to eq Date.new(2018,05,1)

		end
	end
end