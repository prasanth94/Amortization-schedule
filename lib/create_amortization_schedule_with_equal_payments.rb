module CreateAmortizationScheduleWithEqualPayments

  def create_amortization_schedule_with_equal_payments(loan)
  	@loan = loan
  	@amortization_schedule_hash = []
  	@interest_per_period = @loan.interest_rate/(100*12)
  	@beginning_balance = @loan.loan_amount
  	@due_date = @loan.request_date
  	@monthly_payment = calculate_emi

  	calculate_first_month_amortization_schedule
  	calculate_amortization_schedule
   	@amortization_schedule_hash
  end

  private

  def calculate_first_month_amortization_schedule
  	number_of_days_for_first_installment = 31	 - @due_date.day
  	interest_for_first_installment =  @interest_per_period * ( number_of_days_for_first_installment.to_f / 30 )
  	@interest_component = @beginning_balance * interest_for_first_installment
  	find_next_due_date
  	first_month_payment_amount = @monthly_payment - ((@beginning_balance * @interest_per_period) - @interest_component)
  	@principal_component = first_month_payment_amount - @interest_component
  	@ending_balance = @beginning_balance - @principal_component
  	@amortization_schedule_hash.push({ due_date: @due_date, beginning_balance: @beginning_balance, ending_balance: @ending_balance,
  																		interest_component: @interest_component, principal_component: @principal_component,
  																		monthly_payment: first_month_payment_amount })
  end

  def calculate_amortization_schedule
  	(@loan.term - 1).times do
  		@beginning_balance -= @principal_component
  		@interest_component = @beginning_balance * @interest_per_period
  		@principal_component = @monthly_payment - @interest_component
  		@ending_balance = @beginning_balance - @principal_component
  		@due_date = find_next_due_date
  		@amortization_schedule_hash.push({ due_date: @due_date, beginning_balance: @beginning_balance, ending_balance: @ending_balance,
  																		   interest_component: @interest_component, principal_component: @principal_component,
  																		   monthly_payment: @monthly_payment })
  	end
  end

    def calculate_emi
  	((@loan.loan_amount * @interest_per_period) * ((@interest_per_period +1)**@loan.term))/
  					  (((@interest_per_period +1)**@loan.term)-1)
  end

  def find_next_due_date
  	@due_date = @due_date.next_month.at_beginning_of_month
  end

end