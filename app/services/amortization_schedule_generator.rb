class AmortizationScheduleGenerator
  include CreateAmortizationScheduleWithDifferentFirstPayment
  include CreateAmortizationScheduleWithEqualPayments

  def initialize(loan)
    @loan = loan
  end

  def perform
    if @loan.amortization_type == 'First month different payment'
      create_amortization_schedule_with_different_first_payment(principal_amount: @loan.loan_amount,
                                                                interest_rate: @loan.interest_rate,
                                                                term: @loan.term,
                                                                request_date: @loan.request_date)
    else
      create_amortization_schedule_with_equal_payments(principal_amount: @loan.loan_amount,
                                                       interest_rate: @loan.interest_rate,
                                                       term: @loan.term,
                                                       request_date: @loan.request_date)
    end
  end
end
