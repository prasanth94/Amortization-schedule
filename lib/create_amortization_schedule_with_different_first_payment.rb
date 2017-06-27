module CreateAmortizationScheduleWithDifferentFirstPayment
  def create_amortization_schedule_with_different_first_payment(loan)
    @loan = loan
    @amortization_schedule_hash = []
    @interest_per_period = @loan.interest_rate / (100 * 12)
    @beginning_balance = @loan.loan_amount
    @due_date = @loan.request_date
    @monthly_payment = calculate_emi
    calculate_first_month_amortization_schedule_with_different_first_payment
    calculate_amortization_schedule_for_rest_of_months
    @amortization_schedule_hash
  end

  private

  def calculate_first_month_amortization_schedule_with_different_first_payment
    number_of_days_for_interest_in_first_installment = 31 - @due_date.day
    interest_for_first_installment = @interest_per_period * (number_of_days_for_interest_in_first_installment.to_f / 30)
    @interest_component = @beginning_balance * interest_for_first_installment
    find_next_due_date
    first_month_payment_amount = @monthly_payment - ((@beginning_balance * @interest_per_period) - @interest_component)
    @principal_component = first_month_payment_amount - @interest_component
    @ending_balance = @beginning_balance - @principal_component
    push_to_amortization_schedule_hash(first_month_payment_amount)
  end

  def calculate_amortization_schedule_for_rest_of_months
    (@loan.term - 1).times do
      @beginning_balance -= @principal_component
      @interest_component = @beginning_balance * @interest_per_period
      @principal_component = @monthly_payment - @interest_component
      @ending_balance = @beginning_balance - @principal_component
      find_next_due_date
      push_to_amortization_schedule_hash(@monthly_payment)
    end
  end

  def push_to_amortization_schedule_hash(monthly_payment)
    @amortization_schedule_hash.push(due_date: @due_date, beginning_balance: @beginning_balance, ending_balance: @ending_balance,
                                     interest_component: @interest_component, principal_component: @principal_component,
                                     monthly_payment: monthly_payment)
  end

  def calculate_emi
    ((@loan.loan_amount * @interest_per_period) * ((@interest_per_period + 1)**@loan.term)) /
      (((@interest_per_period + 1)**@loan.term) - 1)
  end

  def find_next_due_date
    @due_date = @due_date.next_month.at_beginning_of_month
  end
end
