require 'rails_helper'

RSpec.describe AmortizationScheduleGenerator do
  describe 'initialize' do
    it 'sets @loan instance variable' do
      loan = build :loan
      generator_service = AmortizationScheduleGenerator.new(loan)
      expect(generator_service.instance_variable_get(:@loan)).to eq loan
    end
  end

  describe 'perform' do
    let(:loan) { build :loan }
    it 'should use equal payment amortization schedule generator library if amortization type is Equal Payments' do
      generator_service = AmortizationScheduleGenerator.new(loan)
      expect(generator_service).to receive(:create_amortization_schedule_with_equal_payments)
      generator_service.perform
    end

    it 'should use different first payment amortization schedule generator library if amortization type is Different first payment' do
      loan.amortization_type = 'First month different payment'
      generator_service = AmortizationScheduleGenerator.new(loan)
      expect(generator_service).to receive(:create_amortization_schedule_with_different_first_payment)
      generator_service.perform
    end
  end
end
