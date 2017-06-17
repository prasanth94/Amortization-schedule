class Loan < ActiveRecord::Base
	validates :interest_rate, presence:  true, numericality: {greater_than: 0 },
						:format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }
	validates :loan_amount, presence:  true, 
						 numericality: {only_integer: true, greater_than: 0 }
	validates :term, presence:   true,
						numericality: {only_integer: true, greater_than_or_equal_to: 1 }
	validates :request_date, presence:   true
	validate  :request_date_cannot_be_in_the_future

	def request_date_cannot_be_in_the_future
    errors.add(:request_date, "Request date can't be in the future") if (request_date.present?) && (request_date > Date.today)	
  end
end
		