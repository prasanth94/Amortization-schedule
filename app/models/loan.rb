class Loan < ActiveRecord::Base
	VALID_AMORTIZATION_TYPE = ["Equal payments","First month different payment"]
	validates :interest_rate, presence:  true, numericality: {greater_than: 0 },
						:format => { :with => /\A\d+(?:\.\d{0,2})?\z/, message: "format is incorrect(2 decimal point is only allowed)" }
	validates :loan_amount, presence:  true, 
						 numericality: {only_integer: true, greater_than: 0 }
	validates :term, presence:   true,
						numericality: {only_integer: true, greater_than_or_equal_to: 1 }
	validates :request_date, presence:   true
	validates :amortization_type, presence: true, 
						inclusion: { in: VALID_AMORTIZATION_TYPE , :message => "%{value} is not a valid amortization type" }
	validate  :request_date_cannot_be_in_the_future

	def request_date_cannot_be_in_the_future
    errors.add(:request_date, "Request date can't be in the future") if (request_date.present?) && (request_date > Date.today)	
  end
end
		