module CreateAmortizationSchedule
  def create_amortization_schedule(loan)
  	amortization_schedule_array = []
  	interest_per_period = loan.interest_rate/(100*12)
  	beginning_balance = loan.loan_amount
  	due_date = loan.request_date
  	monthly_payment = calculate_emi(loan)


  	number_of_days_for_first_installment = 31	 - due_date.day
  	interest_for_first_installment =  interest_per_period * ( number_of_days_for_first_installment.to_f / 30 )
  	interest_component = beginning_balance * interest_for_first_installment
  	due_date = find_next_due_date(due_date)
  	first_month_payment_amount = monthly_payment - ((beginning_balance * interest_per_period) - interest_component)
  	principal_component = first_month_payment_amount - interest_component
  	ending_balance = beginning_balance - principal_component
  	amortization_monthly_details = { due_date: due_date, beginning_balance: beginning_balance, ending_balance: ending_balance,
  																		interest_component: interest_component, principal_component: principal_component,
  																		monthly_payment: first_month_payment_amount }
  	amortization_schedule_array.push(amortization_monthly_details)


  	(loan.term - 1).times do
  		beginning_balance -= principal_component
  		interest_component = beginning_balance * interest_per_period
  		principal_component = monthly_payment - interest_component
  		ending_balance = beginning_balance - principal_component
  		due_date = find_next_due_date(due_date)
  		amortization_monthly_details = { due_date: due_date, beginning_balance: beginning_balance, ending_balance: ending_balance,
  																		interest_component: interest_component, principal_component: principal_component,
  																		monthly_payment: monthly_payment }
  		amortization_schedule_array.push(amortization_monthly_details)
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