require 'rails_helper'
require 'equal_payments_amortization_schedule_creator'

RSpec.describe EqualPaymentsAmortizationScheduleCreator do
  describe 'EqualPaymentsAmortizationScheduleCreator' do
    let(:dummy_class) { Class.new }
    before do
      dummy_class.extend(EqualPaymentsAmortizationScheduleCreator)
    end

    it 'returns the amortization schedule for the loan' do
      loan = build(:loan, loan_amount: 10_000, term: 12, interest_rate: 10, request_date: Date.new(2017, 0o5, 15))
      amortization_schedule = dummy_class.equal_payments_amortization_schedule(principal_amount: loan.loan_amount,
                                                                                           term: loan.term,
                                                                                           interest_rate: loan.interest_rate,
                                                                                           request_date: loan.request_date)

      expect(amortization_schedule[0][:principal_component].round(2)).to be_equal 831.32
      expect(amortization_schedule[0][:beginning_balance].round(2)).to be_equal 10_000.00
      expect(amortization_schedule[0][:ending_balance].round(2)).to be_equal 9168.68
      expect(amortization_schedule[0][:interest_component].round(2)).to be_equal 44.44
      expect(amortization_schedule[0][:monthly_payment].round(2)).to be_equal 875.77
      expect(amortization_schedule[0][:due_date]).to eq Date.new(2017, 0o6, 1)

      expect(amortization_schedule[5][:principal_component].round(2)).to be_equal 826.34
      expect(amortization_schedule[5][:beginning_balance].round(2)).to be_equal 5931.03
      expect(amortization_schedule[5][:ending_balance].round(2)).to be_equal 5104.69
      expect(amortization_schedule[5][:interest_component].round(2)).to be_equal 49.43
      expect(amortization_schedule[5][:monthly_payment].round(2)).to be_equal 875.77
      expect(amortization_schedule[5][:due_date]).to eq Date.new(2017, 11, 1)

      expect(amortization_schedule[11][:principal_component].round(2)).to be_equal 868.52
      expect(amortization_schedule[11][:beginning_balance].round(2)).to be_equal 868.52
      expect(amortization_schedule[11][:ending_balance].round(2)).to be_equal 0.00
      expect(amortization_schedule[11][:interest_component].round(2)).to be_equal 7.24
      expect(amortization_schedule[11][:monthly_payment].round(2)).to be_equal 875.76
      expect(amortization_schedule[11][:due_date]).to eq Date.new(2018, 0o5, 1)
    end
  end
end
