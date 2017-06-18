module CreateAmortizationSchedule
  def create_amortization_schedule(loan)
  	amortization_schedule_array = []
  	interest_per_period = loan.interest_rate/(100*12)
  	beginning_balance = loan.loan_amount
  	due_date = find_next_due_date(loan.request_date)
  	monthly_payment = calculate_emi(loan)

  	loan.term.times do
  		interest_component = beginning_balance * interest_per_period
  		principal_component = monthly_payment - interest_component
  		ending_balance = beginning_balance - principal_component
  		due_date = find_next_due_date(due_date)
  		amortization_monthly_details = { due_date: due_date, beginning_balance: beginning_balance, ending_balance: ending_balance,
  																		interest_component: interest_component, principal_component: principal_component,
  																		monthly_payment: monthly_payment }
  		amortization_schedule_array.push(amortization_monthly_details)
  		beginning_balance -= principal_component
  	end
  	amortization_schedule_array
  end

  private

  def calculate_emi(loan)
  	interest_per_period = loan.interest_rate/(100*12)
  	number_of_installments = loan.term
  	monthly_payment = ((loan.loan_amount * interest_per_period) * ((interest_per_period +1)**number_of_installments))/
  					  (((interest_per_period +1)**number_of_installments)-1)
  end

  def find_next_due_date(due_date)
  	due_date = due_date.next_month.at_beginning_of_month
  end

end