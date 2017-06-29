class AmortizationScheduleGenerator
  include DifferentFirstPaymentAmortizationScheduleCreator
  include EqualPaymentsAmortizationScheduleCreator

  def initialize(loan)
    @loan = loan
  end

  def perform
    if @loan.amortization_type == 'First month different payment'
      different_first_payment_amortization_schedule(principal_amount: @loan.loan_amount,
                                                                interest_rate: @loan.interest_rate,
                                                                term: @loan.term,
                                                                request_date: @loan.request_date)
    else
      equal_payments_amortization_schedule(principal_amount: @loan.loan_amount,
                                                       interest_rate: @loan.interest_rate,
                                                       term: @loan.term,
                                                       request_date: @loan.request_date)
    end
  end
end
