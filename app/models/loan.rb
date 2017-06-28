class Loan < ActiveRecord::Base
  include CreateAmortizationScheduleWithDifferentFirstPayment
  include CreateAmortizationScheduleWithEqualPayments

  VALID_AMORTIZATION_TYPE = ['Equal payments', 'First month different payment'].freeze
  validates :interest_rate, presence:  true, numericality: { greater_than: 0 },
                            format: { with: /\A\d+(?:\.\d{0,2})?\z/, message: 'format is incorrect(2 decimal point is only allowed)' }
  validates :loan_amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :term, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :request_date, presence: true
  validates :amortization_type, presence: true,
                                inclusion: { in: VALID_AMORTIZATION_TYPE, message: '%{value} is not a valid amortization type' }
  validate  :request_date_cannot_be_in_the_future

  def amortization_schedule
    if self.amortization_type == 'First month different payment'
      create_amortization_schedule_with_different_first_payment(principal_amount: self.loan_amount,
                           interest_rate: self.interest_rate, term: self.term, request_date: self.request_date)
    else
      create_amortization_schedule_with_equal_payments(principal_amount: self.loan_amount,
                           interest_rate: self.interest_rate, term: self.term, request_date: self.request_date)
    end
  end

  private

  def request_date_cannot_be_in_the_future
    errors.add(:request_date, "Request date can't be in the future") if request_date.present? && (request_date > Date.today)
  end
end
