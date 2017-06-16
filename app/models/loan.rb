class Loan < ActiveRecord::Base
	validates :interest_rate, presence:  true, numericality: {greater_than: 0, less_than_or_equal_to: 20 },
						:format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }
	validates :loan_amount, presence:  true, 
						 numericality: {only_integer: true, greater_than_or_equal_to: 1000, less_than_or_equal_to: 1000000 }
	validates :term, presence:   true,
						numericality: {only_integer: true, greater_than_or_equal_to: 12, less_than_or_equal_to: 120 }
	validates :request_date, presence:  true, timeliness: { on_or_before: lambda { Date.current }, type: :date }
end
		